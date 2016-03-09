//
//  DataController.h
//  TableViewTutorial
//
//  Created by Usman Ismail on 03/09/08.
//  Copyright 2008 University of Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DataController : NSObject 
{
    NSMutableArray *listName;
	NSMutableArray *listIP;
}

- (unsigned)countOfList;
- (id)objectInListAtIndex:(unsigned)theIndex;
- (id)ipInListAtIndex:(unsigned)theIndex;
- (void)addData:(NSString*)data ip:(NSString*)ip;
- (void)removeDataAtIndex:(unsigned)theIndex;

@property (nonatomic, copy, readwrite) NSMutableArray *listName;
@property (nonatomic, copy, readwrite) NSMutableArray *listIP;
@end
