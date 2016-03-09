//
//  TestNetworking2.m
//  try2
//
//  Created by x on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestNetworking2.h"


@implementation TestNetworking2

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    //id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    //STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
#pragma mark ----------- setup ------------
	MyNetwork* networking;
	networking = [[MyNetwork alloc] init];
	[networking StartNetworking:@"192.168.1.200"];
	
	
#pragma mark ------------ test -------------
	int a, b;
	a = 0;
	b = [networking inputCount];
	STAssertEquals( a, b, @"count was not zero, %d", b);
	
	[networking AddToInputFIFO:0];
	[networking AddToInputFIFO:1];
	[networking AddToInputFIFO:2];
	[networking AddToInputFIFO:3];
	[networking AddToInputFIFO:4];
	[networking AddToInputFIFO:5];
	[networking AddToInputFIFO:6];
	[networking AddToInputFIFO:7];
	[networking AddToInputFIFO:8];
	[networking AddToInputFIFO:9];
	[networking AddToInputFIFO:10];
	[networking AddToInputFIFO:11];

	
	unsigned i;

	uint8_t local[512];
	BOOL res;
	
	res = [networking previewNBytes:13 fifo:networking->inputFIFO byt:local];
	STAssertFalse(res, @"preview 13 with %d in there", [networking inputCount]);

	
	res = [networking previewNBytes:12 fifo:networking->inputFIFO byt:local];
	STAssertTrue(res, @"preview 12 with %d in there", [networking inputCount]);
	 
	for( i = 0; i < 12; i++ )
	{
		a = local[i];
		b = i;
		STAssertEquals( a, b, @"comparing local[i], i, = %d, %d", a, b);
	}
	
	
	
//	res = [networking removeNBytes:2 fifo:networking->inputFIFO];

	
#pragma mark ----------- teardown ----------	
	[networking release];	
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void) testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}


#endif


@end
