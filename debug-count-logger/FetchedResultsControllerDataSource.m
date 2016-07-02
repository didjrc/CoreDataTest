//
//  FetchedResultsControllerDataSource.m
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FetchedResultsControllerDataSource.h"
#import "Tricorder.h"
#import "TricorderData.h"

@interface FetchedResultsControllerDataSource ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FetchedResultsControllerDataSource
- (id) initWithTableView:(UITableView *)tableView {
	self = [super init];
	if (self) {
		self.tableView = tableView;
		self.tableView.dataSource = self;
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
//	id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
	return Tricorder.sharedTricorder.numberOfLogs; //determines number of rows to populate in table
}

//- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex
//{
//	id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
//	return section.numberOfObjects;
//}

//- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//	id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//	id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
//	[self.delegate configureCell:cell withObject:object];
//	return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"dataLogCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	cell.selectionStyle = UITableViewCellStyleDefault;
	EczemamaLogger *data = Tricorder.sharedTricorder.recordedData[indexPath.row];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, h:mm:ss"];
	
	cell.textLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data.timestamp / 1000]];
	return cell;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
	return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.delegate deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
	}
}

#pragma mark NSFetchedResultsControllerDelegate
- (void) controllerWillChangeContent:(NSFetchedResultsController *) controller {
	[self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *) controller {
	[self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	if (type == NSFetchedResultsChangeInsert) {
		[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	} else if (type == NSFetchedResultsChangeMove) {
		[self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
	} else if (type == NSFetchedResultsChangeDelete) {
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	} else {
		NSAssert(NO, @"");
	}
}

- (void) setupFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
	NSAssert(_fetchedResultsController == nil, @"TODO: you can currently only assign this property once.");
	_fetchedResultsController = fetchedResultsController;
	fetchedResultsController.delegate = self;
	[fetchedResultsController performFetch:NULL];
}

- (id)selectedItem {
	NSIndexPath *path = self.tableView.indexPathForSelectedRow;
	return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}

- (void)setPaused:(BOOL)paused {
	_paused = paused;
	if (paused) {
		self.fetchedResultsController.delegate = nil;
	} else {
		self.fetchedResultsController.delegate = self;
		[self.fetchedResultsController performFetch:NULL];
		[self.tableView reloadData];
	}
}

@end
