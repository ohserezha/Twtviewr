//
//  ApiManager.h
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <UIKit/UIKit.h>
#import "STTwitter.h"

extern NSString * const kTwitterAccountIsReadyNotification;

@interface ApiManager : NSObject

@property (strong, nonatomic) ACAccount *twitterAccount;
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) STTwitterAPI *stTwitterAPI;

+ (instancetype)sharedInstance;
- (void)loginViaBaseTwitterAccountWithCompletionBlock:(void (^)(void))completionBlock;
- (void)getFeedForUserAccount:(ACAccount *)account onCompletion:(void(^)(NSArray *array))completion onFailure:(void (^)(NSError *error))failure;
- (void)loginViaWebView:(UIWebView *)webView withKey:(NSString *)key andSecret:(NSString *)secret;
- (void)loginViaWebView;
- (void)postTweetWithStatus:(NSString *)statusText onCompletion:(void(^)(void))completion onFailure:(void(^)(NSError *error))failure;
- (BOOL)isConnectedToNetwork;
@end
