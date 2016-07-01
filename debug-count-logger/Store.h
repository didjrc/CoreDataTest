//
//  Store.h
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EczemamaEntity;
@class NSFetchedResultsController;

@interface Store : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (EczemamaEntity *)rootItem;

@end
