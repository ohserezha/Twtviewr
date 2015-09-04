//
//  NewTweetViewController.h
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewTweetViewControllerDelegate <NSObject>
- (void)didSuccessfullyPost;
@end

@interface NewTweetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id <NewTweetViewControllerDelegate> delegate;
@end
