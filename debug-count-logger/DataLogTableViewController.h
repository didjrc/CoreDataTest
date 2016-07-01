//
//  DataLogTableViewController.h
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class FetchedResultsControllerDataSource;
@class Store;
@class EczemamaEntity;

@interface DataLogTableViewController : UITableViewController
@property (nonatomic, strong) EczemamaEntity *parent;

@end