//
//  Store.m
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import "Store.h"
#import <CoreData/CoreData.h>
#import "EczemamaEntity.h"

@implementation Store

- (EczemamaEntity *)rootItem {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"EczemamaEntity"];
	request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", nil];
	NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:NULL];
	EczemamaEntity *rootItem = [objects lastObject];
	if (rootItem == nil) {
		rootItem = [EczemamaEntity insertItemWithTitle:nil parent:nil inManagedObjectContext:self.managedObjectContext];
	}
	return rootItem;
}

@end
