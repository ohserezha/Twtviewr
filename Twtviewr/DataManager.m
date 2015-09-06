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

@interface DataManager ()
@property (strong, nonatomic) NSManagedObjectContext *context;
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

- (instancetype)init {
    self = [super init];
    if (self) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.managedObjectContext)
            self.context = appDelegate.managedObjectContext;
    }
    return self;
}

- (Tweet *)fetchTweetWithID:(NSInteger)idn {
    Tweet *tweet = nil;
    
    return tweet;
}

- (NSArray *)fetchTweetsCount:(NSInteger)count ascendingID:(BOOL)isAscending {
    NSArray *array = [NSArray array];
    
    return array;
}

- (void)putNewTweetIntoDatabase:(Tweet *)tweet {
    
}

- (void)clearDataBase {
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    self.context = appdelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    for (Tweet *t in results) {
        [self.context deleteObject:t];
    }
    [self.context save:&error];
}

- (void)addTweetsArray:(NSArray *)tweetsArray {
    
}
@end
