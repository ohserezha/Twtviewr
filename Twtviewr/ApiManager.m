//
//  ApiManager.m
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import "ApiManager.h"
#import <Social/Social.h>
#import "Reachability.h"


NSString *const kTwitterAccountIsReadyNotification = @"kTwitterAccountIsReadyNotification";
static NSString *const GET_FEED_URL = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
static NSString *const POST_TWEET_URL = @"https://api.twitter.com/1.1/statuses/update.json";
static NSString *const API_KEY = @"Iywo7CJ0S8YJk39gK1I6v2Xtp";
static NSString *const API_SECRET = @"XwNBgzVvS6ln1185FXCfeYahMY08yYYjey5egwmtCKK362kzAh";

@interface ApiManager ()
@end

@implementation ApiManager

+ (instancetype) sharedInstance {
    static ApiManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ApiManager alloc] init];
    });
    return sharedInstance;
}

- (void)loginViaBaseTwitterAccountWithCompletionBlock:(void (^)(void))completionBlock {
    ACAccountStore *accStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccType = [accStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accStore requestAccessToAccountsWithType:twitterAccType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accountsArray = [accStore accountsWithAccountType:twitterAccType];
            ACAccount *account = [accountsArray lastObject];
            [self setTwitterAccount:account];
            if (completionBlock) completionBlock();
        } else {
            NSLog(@"access denied");
        }
        if (error) {
            NSLog(@"Error requesting access to account occured %@", [error localizedDescription]);
        }
    }
     ];
}

- (void)loginViaWebView:(UIWebView *)webView withKey:(NSString *)key andSecret:(NSString *)secret {
    if (webView) {
        self.stTwitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:key consumerSecret:secret];
        [self.stTwitterAPI postTokenRequest:^(NSURL *url, NSString *oauthToken) {
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
        } authenticateInsteadOfAuthorize:NO forceLogin:@(YES) screenName:nil oauthCallback:@"myapp://twitter_access_tokens/" errorBlock:^(NSError *error) {
            NSLog(@"-- error: %@", error);
        }];
    } else {
        NSLog(@"Error! Missing webview");
    }
}

- (void)loginViaWebView {
    [self loginViaWebView:self.webView withKey:API_KEY andSecret:API_SECRET];
}

- (void)getFeedForUserAccount:(ACAccount *)account onCompletion:(void(^)(NSArray *array))completion onFailure:(void (^)(NSError *error))failure {
    NSDictionary* params = @{@"count" : @"100", @"screen_name" : account.username};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:GET_FEED_URL]
                                               parameters:params];
    
    request.account = account;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            if (failure) failure(error);
        } else {
            if (completion) {
                NSError *jsonError;
                NSArray *responseJSON = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingAllowFragments
                                         error:&jsonError];
                completion(responseJSON);
            }
        }
    }];
}

- (void)postTweetWithStatus:(NSString *)statusText onCompletion:(void (^)(void))completion onFailure:(void (^)(NSError *))failure {
    NSURL* url = [NSURL URLWithString:POST_TWEET_URL];
    NSDictionary *params = @{@"status":statusText};
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:url
                                                   parameters:params];
    //add parameter account to method definition
    postRequest.account = self.twitterAccount;
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            if (failure) failure(error);
        } else {
            if (completion) completion();
        }
    }];

}

- (BOOL)isConnectedToNetwork {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

@end
