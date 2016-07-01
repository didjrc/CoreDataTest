//
//  PersistentStack.m
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 7/1/16.
//  Copyright © 2016 DIC. All rights reserved.
//  This code creates a really simple Core Data Stack:
//  one managed object context, which has a persistent store coordinator, which has one persistent store.
//  https://www.objc.io/issues/4-core-data/full-core-data-application/ (NOTE: EczemamaEntity == Item object in this tutorial)
//  http://code.tutsplus.com/tutorials/core-data-from-scratch-nsfetchedresultscontroller--cms-21681
//
//  seems good to revisit:
//  http://code.tutsplus.com/tutorials/core-data-from-scratch-core-data-stack--cms-20926


#import "PersistentStack.h"

@interface PersistentStack ()
@property (nonatomic,strong,readwrite) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSURL* modelURL;
@property (nonatomic,strong) NSURL* storeURL;
@end

@implementation PersistentStack

- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL
{
	self = [super init];
	if (self) {
		self.storeURL = storeURL;
		self.modelURL = modelURL;
		[self setupManagedObjectContext];
	}
	return self;
}

- (void) setupManagedObjectContext {
	self.managedObjectContext =
		[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	self.managedObjectContext.persistentStoreCoordinator =
		[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	NSError *error;
	[self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error];
	
	if (error) {
		NSLog(@"Error: %@", error);
	}
	
	self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

- (NSManagedObjectModel*)managedObjectModel
{
	return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end