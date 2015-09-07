//
//  DataManager.h
//  Twtviewr
//
//  Created by ezkeemo on 9/4/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface DataManager : NSObject
+ (DataManager *)sharedInstance;
- (NSArray *)fetchTweetsArrayAscendingID;
- (void)putTweetsArray:(NSArray *)tweetsArray;
- (void)clearDataBase;
@end
