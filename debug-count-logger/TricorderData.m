//
//  TricorderData.m
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 6/30/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import "TricorderData.h"

static NSUInteger const TricorderDataLength = 11;
@implementation EczemamaLogger

- (instancetype)initWithBytes:(const UInt8 *const)bytes andLength:(NSUInteger)length {
	if (self = [super init]) {
		if (length != TricorderDataLength) {
			NSLog(@"TricorderData size mismatch: got %lu but expected %lu", (unsigned long)length, (unsigned long)TricorderDataLength);
			return nil;
		}
		
		NSMutableData *data = [NSMutableData dataWithBytes:bytes length:length];
		
		const void *subdataBytes;
		NSRange range = {0, 0};
		
		range.location += range.length;
		range.length = 4;
		subdataBytes = [[data subdataWithRange:range] bytes];
		
		_packetId = CFSwapInt32LittleToHost(*(uint32_t*)subdataBytes);
		
		range.location += range.length;
		range.length = 4;
		subdataBytes = [[data subdataWithRange:range] bytes];
		
		_timestamp = CFSwapInt64LittleToHost(*(uint64_t*)subdataBytes) * 1000;
		
		range.location += range.length;
		range.length = 2;
		subdataBytes = [[data subdataWithRange:range] bytes];
		
		_timestamp += CFSwapInt16LittleToHost(*(uint16_t*)subdataBytes);
		
		range.location += range.length;
		range.length = 1;
		subdataBytes = [[data subdataWithRange:range] bytes];
		
		_connectionStatus = CFSwapInt16LittleToHost(*(uint16_t*)subdataBytes);
	}
	
	return self;
}

- (void)log {
	NSLog(@"=========================================================================");
	NSLog(@"packet_id:\t\t\t%d", _packetId);
	NSLog(@"timestamp:\t\t\t%llu", _timestamp);
	NSLog(@"connection_status:\t%d", _connectionStatus);
}

@end