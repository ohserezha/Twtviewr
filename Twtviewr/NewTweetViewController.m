//
//  NewTweetViewController.m
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import "NewTweetViewController.h"
#import <Social/Social.h>
#import "ApiManager.h"

@interface NewTweetViewController () <UITextViewDelegate>
@property (strong, nonatomic) UIView *overlayView;
@end

@implementation NewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.textView setDelegate:self];
    self.textView.text = @"put your tweet text here...";
    self.textView.textColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //optional
//    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonTapped:(id)sender {
    [self.textView endEditing:YES];
    NSString *statusText = self.textView.text;
    [self sendTweetWithText:statusText];
}

- (void)sendTweetWithText:(NSString *)text {
    if (text.length > 140) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too long message"
                                                        message:@"Message has to contain less than 140 symbols"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([text isEqualToString:@"put your tweet text here..."] || text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty message"
                                                        message:@"Have nothing to say?"
                                                       delegate:nil
                                              cancelButtonTitle:@"..."
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self showNetworkActivityView:YES];
        [[ApiManager sharedInstance] postTweetWithStatus:text onCompletion:^{
            [self showNetworkActivityView:NO];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate didSuccessfullyPost];
        } onFailure:^(NSError *error) {
            [self showNetworkActivityView:NO];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Error while posting a tweet occured"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
    
}

- (void)showNetworkActivityView:(BOOL)yesno {
    if (yesno) {
        self.overlayView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
        self.overlayView.backgroundColor = [UIColor lightGrayColor];
        self.overlayView.alpha = 0.5;
        [self.navigationController.view addSubview:self.overlayView];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
    } else {
        if (self.overlayView) {
            [self.activityIndicator stopAnimating];
            [self.overlayView removeFromSuperview];
        }
    }
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    [self.textView becomeFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
