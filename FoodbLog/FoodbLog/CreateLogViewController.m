//
//  CreateLogViewController.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//
#import <Parse/Parse.h>
#import "CreateLogViewController.h"

@interface CreateLogViewController ()


@property (nonatomic) IBOutlet UITextField *foodLogTitleTextField;
@property (nonatomic) IBOutlet UITextField *restaurantSearchTextField;
@property (nonatomic) IBOutlet UITextField *foodLogNotesTextField;

- (void)saveButtonTapped;
- (void)setupNavigationBar;

@end

@implementation CreateLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    
}

-(void)setupNavigationBar {
    
    self.navigationItem.title = @"New FoodLog"; // name for now. Should be changed later. 
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:224.0/255.0 green:35.0/255.0 blue:70.0/255.0 alpha:1.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)snapAPhotoButtonTapped:(UIButton *)sender {
    NSLog(@"snap a photo button tapped");
}


- (IBAction)searchAPicOnInstagramButtonTapped:(UIButton *)sender {
    NSLog(@"search a pic button tapped");

}

- (void)saveButtonTapped {
    
    // sending data to and storing in in Parse. This is a test version.
    PFObject *foodLog = [PFObject objectWithClassName:@"FoodLog"];
    foodLog[@"name"] = self.foodLogTitleTextField.text; //@"Mediterranean Quinoa Bowl";
    foodLog[@"notes"] = self.foodLogNotesTextField.text; 
    [foodLog saveInBackground];
}


@end
