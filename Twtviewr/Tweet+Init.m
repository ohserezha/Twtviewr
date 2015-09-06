//
//  Tweet+Init.m
//  Twtviewr
//
//  Created by ezkeemo on 9/4/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import "Tweet+Init.h"

@implementation Tweet (Init)
- (instancetype)initWithTweetDict:(NSDictionary *)tweetDict forInsertingIntoContext:(NSManagedObjectContext *)context {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
    self.createdAt = tweetDict[@"created_at"];
    self.idn = tweetDict[@"id"];
    self.inReplyTo = tweetDict[@"in_reply_to_screen_name"];
    NSURL *imageURL = [NSURL URLWithString:tweetDict[@"user"][@"profile_image_url"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.profileImage = [NSData dataWithContentsOfURL:imageURL];
    });
    self.text = tweetDict[@"text"];
    self.username = tweetDict[@"user"][@"name"];
    return self;
    return self;
}
@end
