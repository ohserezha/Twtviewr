//
//  ApiManager.h
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@interface ApiManager : NSObject

@property (strong, nonatomic) ACAccount *twitterAccount;

+ (instancetype)sharedInstance;

@end
