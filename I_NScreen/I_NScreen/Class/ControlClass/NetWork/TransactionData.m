//
//  TransactionData.m
//  SHBWaitingNumber
//
//  Created by Chang Youl Lee on 12. 4. 12..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "TransactionData.h"

@implementation TransactionData

@synthesize instance;
@synthesize nTrCode;

@synthesize p_RequestDic;
@synthesize p_RequestArray;

-init
{
	if( self = [super init] )
	{
        nTrCode = 0;
        p_RequestDic = [[NSMutableDictionary alloc] init];
        p_RequestArray = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)dealloc
{
    [super dealloc];
    
//    [p_RequestDic removeAllObjects];
//    [p_RequestArray removeAllObjects];
//    
//    [p_RequestDic release];
//    [p_RequestArray release];
//    
//    p_RequestDic = nil;
//    p_RequestArray = nil;
}


@end
