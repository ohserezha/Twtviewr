//
//  Tweet+Init.h
//  Twtviewr
//
//  Created by ezkeemo on 9/4/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import "Tweet.h"

@interface Tweet (Init)
- (instancetype)initWithTweetDict:(NSDictionary *)tweetDict forInsertingIntoContext:(NSManagedObjectContext *)context;
@end
