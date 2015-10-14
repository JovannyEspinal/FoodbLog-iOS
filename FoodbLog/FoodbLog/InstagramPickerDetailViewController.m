//
//  InstagramPickerDetailViewController.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/13/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "InstagramPickerDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface InstagramPickerDetailViewController ()

@end

@implementation InstagramPickerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.instagramImageView.layer.cornerRadius = 5.0;
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
