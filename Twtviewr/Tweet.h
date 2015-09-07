//
//  Tweet.h
//  Twtviewr
//
//  Created by ezkeemo on 9/7/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSNumber * idn;
@property (nonatomic, retain) NSString * inReplyTo;
@property (nonatomic, retain) NSData * profileImage;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * username;

@end
