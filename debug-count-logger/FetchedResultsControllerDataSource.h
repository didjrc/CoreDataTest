//
//  FetchedResultsControllerDataSource.h
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h> // added

@class NSFetchedResultsController;

@protocol NSFetchedResultsControllerDataSourceDelegate
- (void)configureCell:(id)cell withObject:(id)object;
- (void)deleteObject:(id)object;
@end

@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id<NSFetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic) BOOL paused;

- (id)initWithTableView:(UITableView *)tableView;
- (id)selectedItem;

@end
