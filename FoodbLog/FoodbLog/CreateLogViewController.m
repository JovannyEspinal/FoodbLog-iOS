//
//  CreateLogViewController.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//
#import <Parse/Parse.h>
#import "CreateLogViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "InstagramImagePicker.h"

@interface CreateLogViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic) IBOutlet UITextField *foodLogTitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *foodLogImageView;
@property (strong, nonatomic) UIImage *foodLogImage;
@property (nonatomic) IBOutlet UITextField *restaurantSearchTextField;
@property (weak, nonatomic) IBOutlet UITextField *recipeSearchTextField;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (copy, nonatomic) NSString *lastChosenMediaType;

@property (weak, nonatomic) IBOutlet UIButton *snapAPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *searchAPicButton;

- (void)saveButtonTapped;
- (void)setupNavigationBar;


@end

@implementation CreateLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.foodLogTitleTextField.delegate = self;
    self.restaurantSearchTextField.delegate = self;
    
    [self setupNavigationBar];
    
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;
    

    
    
    //Added formatting to text fields
    [self textFieldFormatting:self.foodLogTitleTextField];
    [self textFieldFormatting:self.restaurantSearchTextField];
    [self textFieldFormatting:self.recipeSearchTextField];
}

#pragma mark - Formatting Methods

//Method for formatting text fields
-(void)textFieldFormatting:(UITextField *)textField{
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 5.0;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [[UIColor orangeColor] CGColor];
}
    

#pragma mark - Navigation Bar methods 

-(void)setupNavigationBar {
    
    self.navigationItem.title = @"🍴🍜🍟🍤🍴"; // is subject to change 
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];

}

-(void)cancelButtonTapped{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - API requests methods 

-(void)instagramRequestForTag:(NSString*)foodName {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067", foodName];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:urlString
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             NSArray *results = responseObject[@"data"];
             
             
             NSMutableArray* searchResults = [[NSMutableArray alloc] init];
             
             // loop through all json posts
             for (NSDictionary *result in results) {
                 ;
                 [searchResults addObject:result[@"images"][@"standard_resolution"][@"url"]];

             }
             
             //pass the searchResults over to the CollectionViewController
             InstagramImagePicker* instagramPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramImagePicker"];
             
             instagramPicker.imageURLArray = searchResults;
             
             [self.navigationController pushViewController:instagramPicker animated:YES];
             
             NSLog(@"%@", searchResults);
             
             
         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
             
         }];
    
}



-(void)foursquareRequestForRestaurantName:(NSString*)restaurantName {
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=VENOVOCEM4E1QVRTGNOCNO40V32YHQ4FMRD0M3K4WBMYQWPS&client_secret=QVM22AMEWXEZ54VBHMGOHYE2JNMMLTQYKOKOSAK0JTGDQBLT&v=20130815&query=%@&intent=global", restaurantName];
    
    
    
}

#pragma mark - Image Picker Controller Delegate methods

- (IBAction)snapAPhotoButtonTapped:(UIButton *)sender {
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    // imagePickerController.allowsEditing = YES;
    [self presentViewController:self.imagePickerController animated:NO completion:nil];

    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    
}


// checks if the device has a camera
- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Device has no camera"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
//    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
//    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//        picker.mediaTypes = mediaTypes;
//        picker.delegate = self;
//        picker.allowsEditing = YES;
//        picker.sourceType = sourceType;
//        [self presentViewController:picker animated:YES completion:NULL];
//    } else {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error accessing media" message:@"Unsupported media source." preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *foodPhotoImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.foodLogImageView.image = foodPhotoImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - search a pic on instagram method

- (IBAction)searchAPicOnInstagramButtonTapped:(UIButton *)sender {
    
    [self instagramRequestForTag:self.foodLogTitleTextField.text];

}

#pragma mark - Save button 

- (void)saveButtonTapped {
    
    // sending data to and storing in in Parse. This is a test version.
    PFObject *foodLog = [PFObject objectWithClassName:@"FoodLog"];
    foodLog[@"name"] = self.foodLogTitleTextField.text;
    //foodLog[@"notes"] = self.foodLogNotesTextField.text; // this property has not been created yet inside the VC
    [foodLog saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
