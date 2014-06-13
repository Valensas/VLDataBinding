VLDataBinding
=============  

###iOS storyboard data binding library.  

* Manage segue life cycle.

```objectivec
//Segue identifier is 'WithOpertionSegue'
//After the segue performs; prepare destination view controller
-(void)didPerformWithOpertionSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination=(UIViewController *)segue.destinationViewController;

}

//Segue identifier is 'AfterOperationSegue'
//Before the segue performs
-(void)willPerformAfterOperationSegue:(id)sender{
    if(...)
      [self performSegueWithIdentifier:@"AfterOperationSegue" sender:sender];
}
```
* Easy table view implementation (VLTableViewController) both static and dynamic UITableViewCells.
* VLTableViewController implementation generates all table view without write any line of code via the tableData property.
* Bind data on the specified keyPath to defined property of the UIView inherited objects. (via undefined key)

if you want to bind the string on the 'name' keypath to text property of the target object
```
bindText  String  name
```

* UITableViewCell carry data through segue to the destination view controller.
* Synchronous operation is observed to manage the segue which is related to this operation.
