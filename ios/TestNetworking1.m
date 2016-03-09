//
//  TestNetworking.m
//  try2
//
//  Created by x on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestNetworking1.h"


@implementation TestNetworking



#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    /*id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
	*/
	
#pragma mark ----------- setup ------------
	MyNetwork* networking;
	networking = [[MyNetwork alloc] init];
	[networking StartNetworking:@"192.168.1.200"];
	
	
#pragma mark ----------- test initial settings -----------
	STAssertEquals((int)0, (int)networking->bConnect,
                   @"bConnect should be 0, but was %d instead!", 
                   networking->bConnect);


#pragma mark ----------- test adding --------------
	uint8_t local[512];
	BOOL res;
	
	[networking AddToInputFIFO:0x54];

	res = [networking previewNBytes:1 fifo:networking->inputFIFO byt:local];

	int a,b;
	a = 0x54;
	b = local[0];
	STAssertEquals(a, b, @"wrote byte 0x54, got 0x%x", local[0]);
	STAssertTrue(res, @"return value for adding single byte");
	
	STAssertEquals((unsigned)1, (unsigned)[networking inputCount], @"wrote 1 byte, size was %d", [networking inputCount]);
	
	
#pragma mark ----------- test null ptr --------------
	
	res = [networking previewNBytes:1 fifo:NULL byt:local];
	STAssertFalse(res, @"with fifo=NULL");

	res = [networking previewNBytes:1 fifo:networking->inputFIFO byt:NULL];
	STAssertFalse(res, @"with byt=NULL");
	
#pragma mark ----------- remove too many bytes (all) ----------
	a = [networking inputCount];
	res = [networking removeNBytes:2 fifo:networking->inputFIFO];
	STAssertFalse(res, @"trying to remove 2 bytes with %d in the queue", a);

	a = 0;
	b = [networking inputCount];
	STAssertEquals( a, b, @"removed all bytes, size should be 0 but was %d", [networking inputCount]);
	
	
#pragma mark ----------- teardown ----------	
	[networking release];
	
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void) testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}


#endif


@end
