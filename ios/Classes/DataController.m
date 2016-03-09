//
//  DataController.m
//  TableViewTutorial
//
//  Created by Usman Ismail on 03/09/08.
//  Copyright 2008 University of Waterloo. All rights reserved.
//

#import "DataController.h"

@implementation DataController
@synthesize listName;
@synthesize listIP;

- (id)init 
{
    if (self = [super init]) 
	{
		NSLog(@"Initilizing DataController");
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

		// Pull possible objects from prefs
		NSMutableArray *loadedIP = [[prefs objectForKey:@"listIP"] mutableCopy];
		NSMutableArray *loadedName = [[prefs objectForKey:@"listName"] mutableCopy];		
		
		NSMutableArray *localList = [[NSMutableArray alloc] init];
		NSMutableArray *localList2 = [[NSMutableArray alloc] init];
		
		// if either loaded object is nil, make an empty one
		if( loadedIP == nil || loadedName == nil )
		{
			NSLog(@"no settings");
			self.listName = localList;//[[prefs objectForKey:@"listName"] mutableCopy];
			self.listIP = localList2;
		}
		else
		{
			NSLog(@"loaded settings");
			self.listName = loadedName;
			self.listIP = loadedIP;
		}

		[loadedIP release];
		[loadedName release];
		
		[localList release];
		[localList2 release];
		
    }
    return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setListName:(NSMutableArray *)newList 
{
    if (listName != newList) 
	{
        [listName release];
        listName = [newList mutableCopy];
    }
}

// Custom set accessor to ensure the new list is mutable
- (void)setListIP:(NSMutableArray *)newList 
{
    if (listIP != newList) 
	{
        [listIP release];
        listIP = [newList mutableCopy];
    }
}


- (unsigned)countOfList 
{
    return [listIP count];
}

- (void)removeDataAtIndex:(unsigned)theIndex
{
	[listIP	removeObjectAtIndex:theIndex];
	[listName removeObjectAtIndex:theIndex];
}

- (id)objectInListAtIndex:(unsigned)theIndex 
{
    return [listName objectAtIndex:theIndex];
}

- (NSString*)ipInListAtIndex:(unsigned)theIndex
{
	return [listIP objectAtIndex:theIndex];
}
- (void)updatePairInList:(unsigned)theIndex data:(NSString*)data ip:(NSString*)ip
{
	[listIP replaceObjectAtIndex:theIndex withObject:ip];
	[listName replaceObjectAtIndex:theIndex withObject:data];
}

#pragma mark --------------------addData------------------------
- (void)addData:(NSString*)data ip:(NSString*)ip
{
	if( data != nil && ip != nil )
	{
    	[listIP addObject:ip];
	    [listName addObject:data];
	}
	// else throw here?
}

- (void)dealloc 
{
    [listIP release];
	[listName release];
    [super dealloc];
}

@end
