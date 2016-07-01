//
//  TricorderData.h
//  debug-count-logger
//
//  Created by Jonathan Reid Chinen on 6/30/16.
//  Copyright © 2016 DIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EczemamaLogger : NSObject

@property (readonly) uint32_t packetId; //4 bytes
@property (readonly) uint64_t timestamp; //4 bytes
@property (readonly) BOOL connectionStatus; //1 byte

- (instancetype)initWithBytes:(const UInt8 *const)bytes andLength:(NSUInteger)length;
- (void)log;

@end