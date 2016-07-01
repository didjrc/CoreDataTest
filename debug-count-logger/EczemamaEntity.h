//
//  EczemamaEntity.h
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//@class EczemamaEntity;
NS_ASSUME_NONNULL_BEGIN

@interface EczemamaEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
//@property (nonatomic, retain) NSString *title;
//@property (nonatomic, assign) NSNumber *order;
//@property (nonatomic, retain) EczemamaEntity *parent;
//@property (nonatomic, retain) NSSet *children;


//+ (instancetype) insertItemWithTitle:(NSString *)title
//							  parent:(EczemamaEntity *)parent
//			  inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
//
//- (NSFetchedResultsController *)childrenFetchedResultsController;

@end

NS_ASSUME_NONNULL_END

#import "EczemamaEntity+CoreDataProperties.h"
