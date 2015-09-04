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

@interface NewTweetViewController ()
@end

@implementation NewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonTapped:(id)sender {
    NSString *statusText = self.textView.text;
    if (statusText.length > 140) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too long message"
                                                        message:@"Message has to contain less than 140 symbols"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.textView endEditing:YES];
        UIView *overlayView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
        overlayView.backgroundColor = [UIColor lightGrayColor];
        overlayView.alpha = 0.5;
        [self.navigationController.view addSubview:overlayView];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        [self postTweetWithStatus:statusText onCompletion:^{
            [self.activityIndicator stopAnimating];
            [overlayView removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate didSuccessfullyPost];
        } onFailure:^(NSError *error){
            [self.activityIndicator stopAnimating];
            [overlayView removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Error while posting a tweet occured"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)postTweetWithStatus:(NSString *)statusText onCompletion:(void(^)(void))completion onFailure:(void(^)(NSError *error))failure {
    NSURL* url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
    NSDictionary *params = @{@"status":statusText};
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:url
                                                   parameters:params];
    postRequest.account = [ApiManager sharedInstance].twitterAccount;
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            if (failure) failure(error);
        } else {
            if (completion) completion();
        }
    }];
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
