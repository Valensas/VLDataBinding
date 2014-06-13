//
//  UIView+PropertyBinding.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "UIView+PropertyBinding.h"
#import <objc/runtime.h>

static void * const BindedObjectsDictKey = (void*)&BindedObjectsDictKey;
static void * const BindedObject = (void*)&BindedObject;
static NSString *BindMapConst=@"BindMapConst";
static NSString * const BindKey = @"bind";

@implementation UIView (PropertyBinding)

#pragma mark - Overrides
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL encoderSelector = @selector(encodeWithCoder:);
        SEL decoderSelector =  @selector(initWithCoder:);
        SEL undefinedKeySelector = @selector(setValue:forUndefinedKey:);
        
        SEL afterEncoderSelector = @selector(afterEncodeWithCoder:);
        SEL afterDecoderSelector =  @selector(afterInitWithCoder:);
        SEL vl_undefinedKeySelector = @selector(vl_setValue:forUndefinedKey:);
        
        Method originalEncoderMethod = class_getInstanceMethod(self, encoderSelector);
        Method originalDecoderMethod = class_getInstanceMethod(self, decoderSelector);
        Method originalUndefinedKeyMethod = class_getInstanceMethod(self, undefinedKeySelector);

        
        Method newEncoderMethod = class_getInstanceMethod(self, afterEncoderSelector);
        Method newDecoderMethod = class_getInstanceMethod(self, afterDecoderSelector);
        Method newUndefinedKeySelector = class_getInstanceMethod(self, vl_undefinedKeySelector);
        
        method_exchangeImplementations(originalEncoderMethod, newEncoderMethod);
        method_exchangeImplementations(originalDecoderMethod, newDecoderMethod);
        method_exchangeImplementations(originalUndefinedKeyMethod, newUndefinedKeySelector);
    });
}
- (void)vl_setValue:(id)value forUndefinedKey:(NSString *)key {
    //only the keys stated with bind keyword
    if ([key hasPrefix:BindKey]) {
        // see if the UndefinedObjects dictionary exists, if not, create it
        
        //remove bind prefix key
        NSString *noPrefixKey=[key substringFromIndex:BindKey.length];
        //lower case first char of the bindable property
        //ex: bindText => obj.self peroperty
        NSString *bindablePropertyKey=[noPrefixKey stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[noPrefixKey substringToIndex:1] lowercaseString]];
        
        NSMutableDictionary *bindDict = nil;
        if ( objc_getAssociatedObject(self, BindedObjectsDictKey) ) {
            bindDict = objc_getAssociatedObject(self, BindedObjectsDictKey);
        }
        else {
            bindDict = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, BindedObjectsDictKey, bindDict, OBJC_ASSOCIATION_RETAIN);
        }
        //check property already exist
        
        if ([self respondsToSelector:NSSelectorFromString(bindablePropertyKey)]) {
            [bindDict setValue:bindablePropertyKey forKey:value];//keyPath - property map
        }else{
            NSString *boolPropertyName=[NSString stringWithFormat:@"is%@",noPrefixKey];
            if ([self respondsToSelector:NSSelectorFromString(boolPropertyName)]) {
                [bindDict setValue:bindablePropertyKey forKey:value];//keyPath - property map
            }else{
                NSLog(@"Missing propery of :%@ for keyPath:%@",self,key);
            }
        }
    }else{
        [self vl_setValue:value forUndefinedKey:key];
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    NSMutableDictionary *undefinedDict = nil;
    if ( objc_getAssociatedObject(self, BindedObjectsDictKey) ) {
        undefinedDict = objc_getAssociatedObject(self, BindedObjectsDictKey);
        return [undefinedDict valueForKey:key];
    }
    else {
        return nil;
    }
}

#pragma mark - Public Methods

- (void)bindWithObject:(id)obj {
    
    // first check ourselves for any bindable properties. Then process our
    // children.
    NSDictionary *bindableKeyPaths = [self bindKeyPaths];
    
    
    if ( bindableKeyPaths ) {
        //check
        BOOL __block binded=false;
        [bindableKeyPaths enumerateKeysAndObjectsUsingBlock:^(id keyPath, id property, BOOL *stop) {
            //check that target keypath exist and not nil
            id val=[obj valueForKeyPath:keyPath];
            if (val) {
                [self setObject:val forProperty:property];
                binded=true;
            }
        }];
        if (binded) {
            objc_setAssociatedObject(self, BindedObject, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    //don't bind dynamic cells
    for ( UIView *subview in [self subviews] ) {
        if(([subview isKindOfClass:[UITableViewCell class]])&&([(UITableViewCell *)subview reuseIdentifier])){
            //NSLog(@"Cell with reuse identifier not binded");
        }else{
            [subview bindWithObject:obj];
        }
    }
}
#pragma mark - Private Methods
- (NSDictionary *)bindKeyPaths {
    if ( objc_getAssociatedObject(self, BindedObjectsDictKey) ) {
        NSDictionary *bindDict = objc_getAssociatedObject(self, BindedObjectsDictKey);
        return bindDict;
    }
    else {
        return nil;
    }
}

- (void)setBindKeyPath:(NSDictionary *)bindKeyPaths {
    objc_setAssociatedObject(self, BindedObjectsDictKey, bindKeyPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)bindedKeyPathOfProperty:(NSString *)propertyKeyPath{
    return [[self bindKeyPaths] objectForKey:propertyKeyPath];
}

-(instancetype)cloneView{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    UIView *clonedView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
    if ([self respondsToSelector:@selector(selectionSegueTemplate)]) {
        [clonedView setValue:[self valueForKey:@"selectionSegueTemplate"] forKey:@"selectionSegueTemplate"];
    }
    if ([self respondsToSelector:@selector(accessoryActionSegueTemplate)]) {
        [clonedView setValue:[self valueForKey:@"accessoryActionSegueTemplate"] forKey:@"accessoryActionSegueTemplate"];
    }
    return clonedView;
}
#pragma mark NSCoding
- (void)afterEncodeWithCoder:(NSCoder *)aCoder{
    [self afterEncodeWithCoder:aCoder];
    NSDictionary *bindMap=[self bindKeyPaths];
    if (bindMap) {
        [aCoder encodeObject:bindMap forKey:BindMapConst];
    }
}

-(id)afterInitWithCoder:(NSCoder *)aDecoder{
    id obj=[self afterInitWithCoder:aDecoder];
    NSDictionary *bindMap=[aDecoder decodeObjectForKey:BindMapConst];
    if (bindMap) {
        [obj setBindKeyPath:bindMap];
    }
    return obj;
}

-(void)setObject:(id)object forProperty:(NSString *)propretyName{
    //get property type
    id val=nil;
    id targetObj=[self valueForKey:propretyName];
    if(![object isKindOfClass:[targetObj class]]){
        if(([targetObj isKindOfClass:[NSString class]])&&
           ([object respondsToSelector:@selector(stringValue)])){
            val=[object stringValue];
        }else
            if([targetObj isKindOfClass:[NSNumber class]]){
                if(object==nil){
                    targetObj=[NSNumber numberWithBool:false];
                }else if ([object isKindOfClass:[NSString class]]){
                    targetObj=[[NSNumberFormatter new] numberFromString:object];
                }
            }else{
                val=object;
            }
    }else{
        val=object;
    }
    if(val){
        [self setValue:val forKey:propretyName];
    }else{
        //NSLog(@"VLPropertyBinding nil for peroperty:%@",propretyName);
    }
}

-(void)setShown:(BOOL)show{
    [self setHidden:!show];
}
-(BOOL)isShown{
    return !self.isHidden;
}

@end
