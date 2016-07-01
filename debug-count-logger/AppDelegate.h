//
//  AppDelegate.h
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 6/30/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PebbleKit/PebbleKit.h>
#import "Tricorder.h"

#import <CoreData/CoreData.h>

@class Store;
@class PersistentStack;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PBPebbleCentralDelegate, PBWatchDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PBWatch *connectedWatch;
@property (weak, nonatomic) PBPebbleCentral *central;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end