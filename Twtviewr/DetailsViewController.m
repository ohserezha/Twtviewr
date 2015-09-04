//
//  DetailsViewController.m
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.tweet) {
        self.textView.text = [self.tweet description];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"We could put useful information from tweet here but the task sounds like Отобразить всю доступную информацию по твиту, so we just put a tweet dictionary's description" delegate:nil cancelButtonTitle:@"Oookaaay" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
