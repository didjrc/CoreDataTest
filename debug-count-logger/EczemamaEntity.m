//
//  EczemamaEntity.m
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//  https://github.com/objcio/issue-4-full-core-data-application/blob/master/Item.m

#import "EczemamaEntity.h"

@implementation EczemamaEntity

// Insert code here to add functionality to your managed object subclass
//@dynamic title;
//@dynamic parent;
//@dynamic children;
//@dynamic order;

//+ (instancetype)insertItemWithTitle:(NSString *)title parent:(EczemamaEntity *)parent inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
//	NSUInteger order = parent.numberOfChildren;
//	EczemamaEntity *eczemamaEntity = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:managedObjectContext];
//	
//	eczemamaEntity.title = title;
//	eczemamaEntity.parent = parent;
//	eczemamaEntity.order = @(order);
//	return eczemamaEntity;
//}
//
//+ (NSString *)entityName {
//	return @"EczemammaEntity";
//}
//
//- (NSUInteger)numberOfChildren {
//	return self.children.count;
//}
//
////To support automatic updates to our table view, we will use a fetched results controller.
////A fetched results controller is an object that can manage a fetch request with a big number of items and is the perfect Core Data companion to a table view:
//-(NSFetchedResultsController *)childrenFetchedResultsController {
//	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
//	request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
//	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
//	return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
//}
//
//- (void) prepareForDeletion {
//	if (self.parent.isDeleted) return;
//	
//	NSSet *siblings = self.parent.children;
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > %@", self.order];
//	NSSet *itemsAfterSelf = [siblings filteredSetUsingPredicate:predicate];
//	[itemsAfterSelf enumerateObjectsUsingBlock:^(EczemamaEntity *sibling, BOOL *stop) {
//		sibling.order = @(sibling.order.integerValue - 1);
//	}];
//}

@end
