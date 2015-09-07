//
//  DataManager.m
//  Twtviewr
//
//  Created by ezkeemo on 9/4/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"
#import "Tweet.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface DataManager ()
@end

@implementation DataManager

+ (DataManager *)sharedInstance {
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

// returns array of NSMANAGEDOBJECTs
- (NSArray *)fetchTweetsArrayAscendingID {
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appdelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"idn" ascending:NO selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescription = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescription];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error fetching tweetsArray from database occured %@", [error localizedDescription]);
    }
    if (fetchedObjects.count > 0) {
        return fetchedObjects;
    }
    return nil;
}

- (void)clearDataBase {
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appdelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    for (Tweet *t in results) {
        [context deleteObject:t];
    }
    [context save:&error];
}

// put array of NSDICTIONARYs
- (void)putTweetsArray:(NSArray *)tweetsArray {
    if (tweetsArray) {
        [self clearDataBase];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSManagedObjectContext *context = appDelegate.managedObjectContext;
            for (NSDictionary *tweetDict in tweetsArray) {
                Tweet *tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
                tweet.createdAt = tweetDict[@"created_at"];
                tweet.idn = tweetDict[@"id"];
                tweet.inReplyTo = NULL_TO_NIL(tweetDict[@"in_reply_to_screen_name"]);
                NSURL *imageURL = [NSURL URLWithString:tweetDict[@"user"][@"profile_image_url"]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    tweet.profileImage = [NSData dataWithContentsOfURL:imageURL];;
                });
                tweet.text = tweetDict[@"text"];
                tweet.username = tweetDict[@"user"][@"screen_name"];
                NSError *error;
                [context save:&error];
                if (error) {
                    NSLog(@"error saving context in addTweetsArray: %@", [error localizedDescription]);
                }
            }
    }
}
@end
