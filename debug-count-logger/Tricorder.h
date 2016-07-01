//
//  Tricorder.h
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 6/30/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import <PebbleKit/PebbleKit.h>

extern NSString *const TricorderDataUpdatedNotification;

@interface Tricorder : NSObject <PBDataLoggingServiceDelegate>

@property (readonly) NSMutableArray *recordedData;
//@property (readonly) NSValue *valueConverted; //test
@property (nonatomic, strong) NSMutableArray *persistDataContainer; //test Container Array of datalogging Arrays
@property (readonly) NSInteger crcMismatches;
@property (readonly) NSInteger duplicatePackets;
@property (readonly) NSInteger outOfOrderPackets;
@property (readonly) NSInteger missingPackets;

+ (instancetype)sharedTricorder;

- (NSString *)connectionStatus;
- (uint32_t)latestPacketId;
- (NSString *)latestPacketTime;
- (NSUInteger)numberOfLogs;
- (void)resetData;

@end