//
//  MyNetwork.h
//  try2
//
//  Created by x on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNetwork : NSObject <NSStreamDelegate> {

//	NSString *computerIP;
//	NSString *computerName;

	NSStream *iStream;
	NSStream *oStream;


@public
	BOOL bStreamHasBytesAvailable;
	BOOL bConnect;
	BOOL BHelloDetected;

	NSMutableArray *inputFIFO;
	NSMutableArray *outputFIFO;
	
	
}


- (void) sendCommand:(int)command;
- (void) sendCommandByte:(int)command param:(Byte)param;
- (void) StartNetworking:(NSString *)ip;
- (void) StopNetworking;
- (void) AddToInputFIFO:(Byte) b;
- (void) AddToOutputFIFO:(Byte)b;
- (unsigned) inputCount;
- (unsigned) outputCount;
- (BOOL) previewNBytes:(unsigned)num fifo:(NSMutableArray*)fifo byt:(uint8_t*)byt;
- (BOOL) removeNBytes:(unsigned)num fifo:(NSMutableArray*)fifo;
- (unsigned) ProcessOutputFIFO;
- (void) ProcessInputFIFO;

- (int) readCommand:(int*)commandBack paramBack:(int*)paramBack paramBack2:(int*)paramBack2;

- (double) ReceiveRangeFloat:(char)MS LS:(char)LS;
- (int) ReceiveRangeInt:(char)MS LS:(char)LS;
- (char) TransmitRangeFloatMS:(double)value;
- (char) TransmitRangeFloatLS:(double)value;
- (char) TransmitRangeIntLS:(int)value;
- (char) TransmitRangeIntMS:(int)value;
@end
