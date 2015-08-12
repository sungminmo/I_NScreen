//
//  DataManager.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import "DataManager.h"


@implementation DataManager

// 공통컨트롤 클래스 선언
@synthesize p_gUserClass;

// 최상위 뷰클래스
@synthesize p_gViewController;

static DataManager *instance = nil;

+ (DataManager *)getInstance
{
	@synchronized(self)
	{
		if (instance == nil)
		{
			[[self alloc] init];
		}
	}
	
	return instance;
}

- (id)init
{
	@synchronized(self)
	{
		[super init];
	}
	return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [super allocWithZone:zone];
			return instance;
		}
	}
	return nil;
}

- (void)execute
{
    // 공통컨트롤 클래스 선언
    p_gUserClass = [[UserClass alloc] init];
    // 최상위 뷰클래스
    p_gViewController = nil;
}

@end
