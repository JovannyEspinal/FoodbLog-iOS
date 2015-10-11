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

- (void)saveButtonTapped;
@property (nonatomic) IBOutlet UITextField *foodLogTitleTextField;
@property (nonatomic) IBOutlet UITextField *restaurantSearchTextField;
@property (nonatomic) IBOutlet UITextField *foodLogNotesTextField;



@end

@implementation CreateLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonTapped {
    
    // sending data to and storing in in Parse. This is a test version.
    PFObject *foodLog = [PFObject objectWithClassName:@"FoodLog"];
    foodLog[@"name"] = self.foodLogTitleTextField.text; //@"Mediterranean Quinoa Bowl";
    foodLog[@"notes"] = self.foodLogNotesTextField.text; 
    [foodLog saveInBackground];
}

@end
