//
//  DetailsViewController.h
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) NSDictionary *tweet;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
