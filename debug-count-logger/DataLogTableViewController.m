//
//  DataLogTableViewController.m
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import "DataLogTableViewController.h"
#import "Tricorder.h"
#import "TricorderData.h"
#import "FetchedResultsControllerDataSource.h"
#import "Store.h"
#import "EczemamaEntity+CoreDataProperties.h"

static NSString *const selectItemSegue = @"selectItem"; //added
@interface UITableViewController () <NSFetchedResultsControllerDataSourceDelegate, UITextFieldDelegate>

@property (nonatomic, strong) FetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property (nonatomic, strong) UITextField *titleField;

@end

@implementation DataLogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self setupFetchedResultsController];
	[self setupNewItemField];
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:TricorderDataUpdatedNotification object:[Tricorder sharedTricorder] queue:nil
												  usingBlock:^(NSNotification *note) {
													  [self.tableView reloadData];
												  }];
	if ([self.tableView numberOfRowsInSection:0] > 0) {
		[self hideNewItemField];
	}
	self.fetchedResultsControllerDataSource.paused = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.fetchedResultsControllerDataSource.paused = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TricorderDataUpdatedNotification object:[Tricorder sharedTricorder]];
}

- (void)setupFetchedResultsController
{
	self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
	self.fetchedResultsControllerDataSource.fetchedResultsController = self.parent.childrenFetchedResultsController;
	self.fetchedResultsControllerDataSource.delegate = self;
	self.fetchedResultsControllerDataSource.reuseIdentifier = @"DataLogCell";
}

- (void)setupNewItemField
{
	self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableView.rowHeight)];
	self.titleField.delegate = self;
	self.titleField.placeholder = NSLocalizedString(@"Add a new item", @"Placeholder text for adding a new item");
	self.tableView.tableHeaderView = self.titleField;
}

#pragma mark Fetched Results Controller Delegate
- (void)configureCell:(id)theCell withObject:(id)object {
	UITableViewCell *cell = theCell;
	EczemamaEntity *eczemamaEntity = object;
	cell.textLabel.text = eczemamaEntity.accelData;
}

- (void)deleteObject:(id)object {
	EczemamaEntity *eczemamaEntity = object;
	NSString *actionName = [NSString stringWithFormat:NSLocalizedString(@"Delete \"%@\"", @"Delete undo action name"), eczemamaEntity.accelData];
	[self.undoManager setActionName:actionName];
	[eczemamaEntity.managedObjectContext deleteObject:eczemamaEntity];
}

#pragma mark Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	if ([segue.identifier isEqualToString:selectItemSegue]) {
		[self presentSubDataLogTableViewController:segue.destinationViewController];
	}
}

- (void) presentSubDataLogTableViewController : (DataLogTableViewController *)subDataLogTableViewController {
	EczemamaEntity *eczemamaEntity = [self.fetchedResultsControllerDataSource selectedItem];
	subDataLogTableViewController.parent = eczemamaEntity;
}

- (BOOL) textFieldShouldReturn : (UITextField *)textField {
	NSString *title = textField.text;
	NSString *actionName = [NSString stringWithFormat:NSLocalizedString(@"add item \'%@\"", @"Undo action name of add item"), title];
	[self.undoManager setActionName:actionName];
	[EczemamaEntity insertItemWithTitle:title parent:self.parent inManagedObjectContext:self.managedObjectContext];
	textField.text = @"";
	[textField resignFirstResponder];
	[self hideNewItemField];
	return NO;
}

- (NSManagedObjectContext*)managedObjectContext
{
	return self.parent.managedObjectContext;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
	if (-scrollView.contentOffset.y > self.titleField.bounds.size.height) {
		[self showNewItemField];
	} else if (scrollView.contentOffset.y > 0) {
		[self hideNewItemField];
	}
}

- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset
{
	BOOL itemFieldVisible = self.tableView.contentInset.top == 0;
	if (itemFieldVisible) {
		[self.titleField becomeFirstResponder];
	}
}

- (void)showNewItemField
{
	UIEdgeInsets insets = self.tableView.contentInset;
	insets.top = 0;
	self.tableView.contentInset = insets;
}

- (void)hideNewItemField
{
	UIEdgeInsets insets = self.tableView.contentInset;
	insets.top = -self.titleField.bounds.size.height;
	self.tableView.contentInset = insets;
}

- (void)setParent:(EczemamaEntity *) parent {
	_parent = parent;
	self.navigationItem.title = parent.accelData;
}

#pragma mark Undo

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (NSUndoManager*)undoManager
{
	return self.managedObjectContext.undoManager;
}

// =============== PREEXISTING -- WORKS
/*
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return Tricorder.sharedTricorder.numberOfLogs; //determines number of rows to populate in table
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"dataLogCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	cell.selectionStyle = UITableViewCellStyleDefault;
	EczemamaLogger *data = Tricorder.sharedTricorder.recordedData[indexPath.row];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, h:mm:ss:SSS"];
	
	cell.textLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data.timestamp / 1000]];
	return cell;
}
 */
// ==================== OLD -- WORKS
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
