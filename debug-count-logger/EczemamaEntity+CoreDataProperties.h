//
//  EczemamaEntity+CoreDataProperties.h
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EczemamaEntity.h"
@class EczemamaEntity;
NS_ASSUME_NONNULL_BEGIN

@interface EczemamaEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSNumber *accelData;
@property (nullable, nonatomic, retain) EczemamaEntity *parent;
@property (nullable, nonatomic, retain) NSSet *child;

+ (instancetype) insertItemWithTitle:(NSString *)title
							  parent:(EczemamaEntity *)parent
			  inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (NSFetchedResultsController *)childrenFetchedResultsController;

@end

NS_ASSUME_NONNULL_END
