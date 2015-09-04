//
//  ApiManager.m
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import "ApiManager.h"

@implementation ApiManager

+ (instancetype) sharedInstance {
    static ApiManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ApiManager alloc] init];
    });
    return sharedInstance;
}

@end
