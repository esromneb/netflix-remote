//
//  MyNetwork.m
//  try2
//
//  Created by x on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyNetwork.h"


@implementation MyNetwork


- (id)init {
	if ((self = [super init])) {
		//m_socket = socket(AF_INET, SOCK_STREAM, 0);
	}
	
	inputFIFO = [[NSMutableArray alloc] init];
	outputFIFO = [[NSMutableArray alloc] init];
	
	
    bConnect = FALSE;
	BHelloDetected = FALSE;
	
	return self;
}
/*
- (void) sendCommand:(int)command {
	if (!command) {
		return;
	}
	[self AddToOutputFIFO:0x50];
	[self AddToOutputFIFO:0x51];
	[self AddToOutputFIFO:0x52];
	[self AddToOutputFIFO:0x50 + command];

	[self ProcessOutputFIFO];
}*/

- (void) sendCommandByte:(int)command param:(Byte)param {
	if (!command) {
		return;
	}
	[self AddToOutputFIFO:0x50];
	[self AddToOutputFIFO:0x51];
	[self AddToOutputFIFO:0x52];
	[self AddToOutputFIFO:0x50 + command];
	[self AddToOutputFIFO:param];
	
	[self ProcessOutputFIFO];
}

- (void) sendCommandBytes:(int)command param:(Byte)param param2:(Byte)param2 {
	if (!command) {
		return;
	}
	[self AddToOutputFIFO:0x50];
	[self AddToOutputFIFO:0x51];
	[self AddToOutputFIFO:0x52];
	[self AddToOutputFIFO:0x50 + command];
	[self AddToOutputFIFO:param];
	[self AddToOutputFIFO:param2];
	
	[self ProcessOutputFIFO];
	
}

// return success?
// if num is larger, returns false and does nothing
- (BOOL) previewNBytes:(unsigned)num fifo:(NSMutableArray*)fifo byt:(uint8_t*)byt
{
	
	if( fifo == nil )
		return FALSE;
	
	if( byt == nil )
		return FALSE;

	if( num > [fifo count] )
		return FALSE;
	
	// short circuit if 0 size, not failure tho
	if( num == 0 )
		return TRUE;

	unsigned i;
	NSNumber *out;
	
	for( i = 0; i < num; i++ )
	{
		out = [fifo objectAtIndex:i];  // take out the first one
		byt[i] = [out intValue];
	}
	
	return TRUE;
}

// returns success?
// if num > avaliable bytes, will return false but remove all bytes
- (BOOL) removeNBytes:(unsigned)num fifo:(NSMutableArray*)fifo
{
//	NSNumber *out;
//	out = [inputFIFO objectAtIndex:0];  // take out the first one
	
	if( fifo == nil )
		return FALSE;

	unsigned i;
	for( i = 0; i < num; i++ )
	{
		if( [fifo count] == 0 )
			return FALSE;
		[fifo removeObjectAtIndex:0];		
	}
}


- (unsigned) inputCount
{
	return [inputFIFO count];
}

- (unsigned) outputCount
{
	return [outputFIFO count];
}

// returns bool hellodetected?
- (bool) detectHello {
	


	//NSNumber *out;
	
	// THIS loop cannot be interrupted by any process
	// removing from input queue. Adding is ok
	uint8_t buffer[1024];
	BOOL ret;
	ret = [self previewNBytes:5 fifo:inputFIFO byt:buffer];
	
	// not enough bytes in buffer
	if (ret == FALSE)
	{
		return FALSE;
	}
	
	int i = 0;
	/*for( i = 0; i < 5; i ++ )
	{
		NSLog(@"%d", buffer[i]);	
	}*/

	
	int startByte = 0x40;
	int flagFail = 0;	

	for( i = 0; i < 5; i++ )
	{
		if( buffer[i] != startByte++ )
		{
			flagFail = 1;
		}
	}
	
	if( !flagFail )
	{
	//	txtStatus.text = @"Got Hello";
		NSLog(@"GGGGGGGGGot HELLO!");
		[self removeNBytes:5 fifo:inputFIFO];
	}
	
	return !flagFail;
}

- (int) readCommand:(int*)commandBack paramBack:(int*)paramBack paramBack2:(int*)paramBack2
{
	// THIS loop cannot be interrupted by any process
	// removing from input queue. Adding is ok
	uint8_t buffer[1024];
	BOOL ret;
	ret = [self previewNBytes:6 fifo:inputFIFO byt:buffer];
	
	// not enough bytes in buffer
	if (ret == FALSE)
	{
		return -1;
	}
	
	int i = 0;
	/*for( i = 0; i < 6; i ++ )
	{
		NSLog(@"0x%x", buffer[i]);	
	}*/
	
	
	int startByte = 0x50;
	int flagFail = 0;	
	
	for( i = 0; i < 3; i++ )
	{
		if( buffer[i] != startByte++ )
		{
			flagFail = 1;
		}
	}
	
	int readCommand = buffer[3] - 0x50;
	int readParam = buffer[4];
	int readParam2 = buffer[5];
	

	if( !flagFail )
	{
		//NSLog(@"Read command 0x%x with param %d", readCommand, readParam);
		*commandBack = readCommand;
		*paramBack = readParam;
		*paramBack2 = readParam2;
		[self removeNBytes:6 fifo:inputFIFO];
	}
	else
	{
		commandBack = 0;
		paramBack = 0;
		paramBack2 = 0;
	}

	
	return !flagFail;	
}

 
- (void) sendHello {
	int i = 0;
	int startByte = 0x40;
	for( i = 0; i < 5; i ++ )
	{
		NSLog( @"sent byte: %d", startByte );
		[self AddToOutputFIFO: startByte++];
		//[self AddToOutputFIFO: 0];
	}
	[self ProcessOutputFIFO];
}




- (void) Stats {
	NSLog(@"  Input  size: %d", [self inputCount]  );
	NSLog(@"  Output size: %d", [self outputCount] );
}

- (void) AddToOutputFIFO:(Byte)b {
	NSNumber *num = [NSNumber numberWithInteger:b];
	[outputFIFO addObject: num]; // adds at end	
}

- (void) AddToInputFIFO:(Byte)b {
	NSNumber *num = [NSNumber numberWithInteger:b];
    [inputFIFO addObject: num];  // adds at end
}

// interp commands already received
- (void) ProcessInputFIFO
{
	unsigned num = [self inputCount];
//inputFIFO.
  //  NSLog(@"counted %d", num);
	
//	NSNumber *out;
//	out = [inputFIFO objectAtIndex:0];  // take out the first one
//	[inputFIFO removeObjectAtIndex:0];	
//	NSLog(@"Removed %@", out);
	
}


// Send chars waiting in buffer
// returns chars processed
- (unsigned) ProcessOutputFIFO
{
	unsigned i;
	
	if( !bStreamHasBytesAvailable )
		return 0;

	//count bytes in fifo
	unsigned outstandingBytes;
	outstandingBytes = [self outputCount];
	
	// shortcut if 0 outstanding
	if( outstandingBytes == 0 )
		return 0;
	
	
	//alocate classic byte array with count
	uint8_t buffer[outstandingBytes];				
	int bytesWritten;
	
	//Fetch bytes from FIFO
	[self previewNBytes:outstandingBytes fifo:outputFIFO byt:buffer];
	
	// write, save #written
	bytesWritten = [oStream write:buffer maxLength:sizeof(buffer)];

	if (bytesWritten > 0)
	{
		NSLog(@"Command send");
		//[oStream close];
	}
	
	[self removeNBytes:bytesWritten fifo:outputFIFO];
	
	if( bytesWritten != outstandingBytes )
	{
		NSLog(@"not all bytes sent, trying for %d got %d", outstandingBytes, bytesWritten);
		return 0;
	}
	
	return bytesWritten;
}

 

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	NSString *io;
	if (theStream == iStream) io = @">>";
	else io = @"<<";
	
	NSString *event;
	unsigned iterator;
	switch (streamEvent)
	{
		case NSStreamEventNone:
			event = @"NSStreamEventNone";
	//		resultText.font = [UIFont fontWithName:@"Helvetica" size:10.0];
	//		resultText.textColor = [UIColor whiteColor];
	//		resultText.text = [[NSString alloc] initWithFormat: @"Can not connect to the host!"];
			break;
		case NSStreamEventOpenCompleted:
			event = @"NSStreamEventOpenCompleted";
			break;
		case NSStreamEventHasBytesAvailable:
			event = @"NSStreamEventHasBytesAvailable";
			if (theStream == iStream)
			{
				//read data
				uint8_t buffer[1024];
				int len;
				while ([iStream hasBytesAvailable])
				{
					len = [iStream read:buffer maxLength:sizeof(buffer)];

				//	NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
				//	NSData *theData = [[NSData alloc] initWithBytes:buffer length:len];
				//	if (nil != output)
					
					if (len > 0)
					{
						for( iterator = 0; iterator < len; iterator++ )
						{
							[self AddToInputFIFO:buffer[iterator] ];
						}
					}
				}
			}
			break;
		case NSStreamEventHasSpaceAvailable:
			event = @"NSStreamEventHasSpaceAvailable";
			if (theStream == oStream)
			{
				unsigned count;
				count = [self ProcessOutputFIFO];
				
				// if count is 0 we didn't send any bytes
				// this means we should set the bool.
				// if we DID send bytes, leave the bool alone.
				// the stream should give us another event in this case
				if( count == 0 )
				{
					bStreamHasBytesAvailable = TRUE;
				}
				
				//http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Streams/Articles/WritingOutputStreams.html
								
			}
			break;
		case NSStreamEventErrorOccurred:
			event = @"NSStreamEventErrorOccurred";
//			resultText.font = [UIFont fontWithName:@"Helvetica" size:10.0];
//			resultText.textColor = [UIColor whiteColor];
//			resultText.text = [[NSString alloc] initWithFormat: @"Can not connect to the host!"];
//			NSLog(@"Can not connect to the host!");
			break;
		case NSStreamEventEndEncountered:
			event = @"NSStreamEventEndEncountered";
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [theStream release];
            theStream = nil;
			
			break;
		default:
			event = @"** Unknown";
	}
	
	NSLog(@"%@ : %@", io, event);

	[self ProcessInputFIFO];
	
}


-(void)StartNetworking:(NSString *)ip{   
	BHelloDetected = 0;
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)ip, 42000, &readStream, &writeStream);
    if (readStream && writeStream) {
        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
		
        iStream = (NSInputStream *)readStream;
        [iStream retain];
        [iStream setDelegate:self];
        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [iStream open];
		
        oStream = (NSOutputStream *)writeStream;
        [oStream retain];
        [oStream setDelegate:self];
        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [oStream open];         
    }
    if (readStream) CFRelease(readStream);
    if (writeStream) CFRelease(writeStream);
}

-(void)StopNetworking {
		if( iStream )
		{
			[iStream close];
		}
		if( oStream )
		{
			[oStream close];
		}
}


#pragma mark --------------- Special 2 byte tx/rx ----------------------

// We (AHK) can only transmit characters from 34 to 127 inclusive.
// 127 - 34 is 93.  If we use 2 chars, this gives us 93*93 aka 8649 possible values


-(char)TransmitRangeIntMS:(int)value
{
	return floor( value / 94 ) + 34;
}
-(char)TransmitRangeIntLS:(int)value
{
	return (value % 94 )+34;
}
	
// value is from 0.0 to 1.0
-(char)TransmitRangeFloatLS:(double)value
{
	int intval;
	// use floor + 0.5 to get the effect of round()
	intval = floor( (float) (value * 8649.0) + 0.5 );
	return [self TransmitRangeIntLS:intval];
}

-(char)TransmitRangeFloatMS:(double)value
{
	int intval;
	// use floor + 0.5
	intval = floor( (value * 8649) + 0.5 );
	return [self TransmitRangeIntMS:intval];
}

-(int)ReceiveRangeInt:(char)MS LS:(char)LS
{
	MS = MS - 34;
	LS = LS - 34;
	
	return MS*94 + LS;
}

-(double)ReceiveRangeFloat:(char)MS LS:(char)LS
{
	double fval;
	fval = [self ReceiveRangeInt:MS LS:LS];
	return (fval / 8649.0);
}



/*
 for( i = 0; i < 101; i++ )
 {
 ms = [networking TransmitRangeIntMS:i];
 ls = [networking TransmitRangeIntLS:i];
 original = [networking ReceiveRangeInt:ms LS:ls];
 NSLog(@"%d - %d .... = %d", ms, ls, original );
 }
 
 for( i = 0; i < 101; i++ )
 {
 fms = i / 100.0;
 fls = i / 100.0;
 ms = [networking TransmitRangeFloatMS:fms];
 ls = [networking TransmitRangeFloatLS:fls];
 foriginal = [networking ReceiveRangeFloat:ms LS:ls];
 iinput = i / 100.0;
 NSLog(@"%d - %d .... = %f", ms, ls, foriginal);//%ms% - %ls% ..... = %original%  - %iinput%
 }*/




/*
 - (void) StartNetworking {
 
 NSString* serverAddress = @"192.168.1.200";
 NSString* server_port = @"42000";
 //	NSHost* host;
 //	host = [NSHost hostWithAddress:@"192.42.172.1"];
 NSHost* host = [NSHost hostWithName:serverAddress];
 //NSHost* abas = [NSHost hostWithAddress:ser
 if( host ) {
 [NSStream getStreamsToHost:host port:server_port inputStream:&iStream outputStream:&oStream] ;
 
 if( nil != iStream && nil != oStream ) {
 [iStream retain];
 [oStream retain];
 
 [iStream setDelegate:self] ;
 [oStream setDelegate:self] ;
 
 [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
 forMode:NSDefaultRunLoopMode];
 [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
 forMode:NSDefaultRunLoopMode];
 [iStream open];
 [oStream open];			
 bConnect = TRUE ;
 }
 
 NSLog(@"input stream %@", nil==iStream?@"was not created":@"was created");
 NSLog(@"output stream %@", nil==oStream?@"was not created":@"was created");
 }
 
 
 NSString * str = [NSString stringWithFormat:
 @"@ABCD"];
 const uint8_t * rawstring =
 (const uint8_t *)[str UTF8String];
 [oStream write:rawstring maxLength:strlen(rawstring)];
 
 
 }
 */





/*
 - (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
 
 unsigned buffer[1024];
 int len;
 
 NSLog(@"stream event %d", eventCode) ;
 if( stream == iStream ) NSLog(@"on input stream");
 else if( stream == oStream ) NSLog(@"on output stream");
 else NSLog(@"on unknown stream identifier") ;
 
 switch(eventCode) {
 case NSStreamEventEndEncountered:
 {
 NSLog(@"stream ended; will be closed") ;
 [stream close];
 [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
 forMode:NSDefaultRunLoopMode];
 [stream release];
 stream = nil; // stream is ivar, so reinit it
 break;
 }
 case NSStreamEventErrorOccurred:
 NSLog(@"stream error") ;
 break ;
 
 case NSStreamEventHasBytesAvailable:
 //to-do: read here
 //read data
 
 while ([iStream hasBytesAvailable])
 {
 len = [iStream read:buffer maxLength:sizeof(buffer)];
 NSLog(@"NEW: read %d bytes", len);
 }
 
 
 break ;
 
 case NSStreamEventNone:
 NSLog(@"stream null event") ;
 break ;
 
 case NSStreamEventOpenCompleted:
 NSLog(@"stream is now open") ;
 break ;
 
 case NSStreamEventHasSpaceAvailable:
 //write here
 break ;
 }
 
 }
 */




@end

