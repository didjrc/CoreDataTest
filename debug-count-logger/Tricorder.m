//
//  Tricorder.m
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 6/30/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import "Tricorder.h"

#import "AppDelegate.h"
#import "TricorderData.h"

NSString *const TricorderDataUpdatedNotification = @"tricorderUpdated";

@interface Tricorder ()

@property NSMutableArray *packetIds;

@end

@implementation Tricorder

+ (instancetype)sharedTricorder {
	static Tricorder *sharedTricorder = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedTricorder = [[self alloc] init];
	});
	return sharedTricorder;
}

- (instancetype)init {
	if (self = [super init]) {
		_recordedData = [[NSMutableArray alloc] init];
		_packetIds = [[NSMutableArray alloc] init];
	}
	return self;
}

//http://nshipster.com/nscoding/
//must try:
//see: http://iphonedevsdk.com/forum/iphone-sdk-development/16205-saving-class-nsuserdefaults.html
//see: http://stackoverflow.com/questions/2315948/how-to-store-custom-objects-in-nsuserdefaults

- (NSString *)connectionStatus {
	return self.latestData.connectionStatus ? @"Connected" : @"Disconnected";
}

- (uint32_t)latestPacketId {
	return self.latestData.packetId;
}

- (NSString *)latestPacketTime {
	if (_recordedData.count == 0) {
		return @"N/A";
	}
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, h:mm:ss.SSS"];
	return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.latestData.timestamp / 1000]];
}

- (NSUInteger)numberOfLogs {
	return _recordedData.count;
}

- (EczemamaLogger *)latestData {
	//- (TricorderData *)latestData {
	return _recordedData.firstObject;
}

- (void)resetData {
	_crcMismatches = 0;
	_duplicatePackets = 0;
	_outOfOrderPackets = 0;
	_missingPackets = 0;
	[_recordedData removeAllObjects];
	[_packetIds removeAllObjects];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:TricorderDataUpdatedNotification object:self];
}

#pragma mark - PBDataLoggingServiceDelegate

- (BOOL)dataLoggingService:(PBDataLoggingService *)service
			 hasByteArrays:(const UInt8 *const)bytes
			 numberOfItems:(UInt16)numberOfItems
	 forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
	for (NSUInteger i = 0; i < numberOfItems; i++) {
		const uint8_t *logBytes = &bytes[i * session.itemSize];
		
		//        TricorderData *data = [[TricorderData alloc] initWithBytes:logBytes andLength:session.itemSize];
		EczemamaLogger *data = [[EczemamaLogger alloc] initWithBytes:logBytes andLength:session.itemSize];
		[data log];
		
		if (data.packetId == 1) {
			[self resetData];
		}
		
		if (data.packetId < self.latestPacketId) {
			_outOfOrderPackets++;
		}
		
		if ([_packetIds containsObject:@(data.packetId)]) {
			_duplicatePackets++;
		}
		
		[_packetIds addObject:@(data.packetId)];
		[_recordedData insertObject:data atIndex:0];
	}
	_missingPackets = [[_packetIds valueForKeyPath:@"@max.self"] intValue] - (_recordedData.count - _duplicatePackets);
	return YES;
}

- (void)dataLoggingService:(PBDataLoggingService *)service
		  sessionDidFinish:(PBDataLoggingSessionMetadata *)session {
	[[NSNotificationCenter defaultCenter] postNotificationName:TricorderDataUpdatedNotification object:self];
}

@end
