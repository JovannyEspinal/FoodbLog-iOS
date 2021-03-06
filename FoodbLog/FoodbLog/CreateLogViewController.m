//
//  CreateLogViewController.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//
#import <Parse/Parse.h>
#import <AFNetworking/AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@import UIKit;
#import "CreateLogViewController.h"
#import "InstagramImagePicker.h"
#import "FDBLogData.h"

@interface CreateLogViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate, InstagramImagePickerDelegate, UIActionSheetDelegate>


@property (nonatomic) IBOutlet UITextField *foodLogTitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *foodLogImageView;
@property (strong, nonatomic) UIImage *foodLogImage;
@property (nonatomic) IBOutlet UITextField *restaurantSearchTextField;
@property (weak, nonatomic) IBOutlet UITextField *recipeSearchTextField;
@property (weak, nonatomic) IBOutlet UITextView *foodExperienceTextView;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (copy, nonatomic) NSString *lastChosenMediaType;

@property (weak, nonatomic) IBOutlet UIButton *snapAPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *searchAPicButton;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic) CLLocation* userLocation;

- (void)saveButtonTapped;
- (void)setupNavigationBar;

- (BOOL)shouldPresentPhotoCaptureController;

@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;


@end

@implementation CreateLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    [self.locationManager setDelegate:self]; // we set the delegate of locationManager to self.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];

    [self.locationManager startUpdatingLocation];
   
    self.foodLogTitleTextField.delegate = self;
    self.restaurantSearchTextField.delegate = self;
    self.recipeSearchTextField.delegate = self;
    
    [self setupNavigationBar];
    
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;
    

    
    
    //Added formatting to text fields
    [self textFieldFormatting:self.foodLogTitleTextField];
    [self textFieldFormatting:self.restaurantSearchTextField];
    [self textFieldFormatting:self.recipeSearchTextField];
    
    self.foodExperienceTextView.delegate = self;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.foodLogImageView.layer.masksToBounds = YES;
    self.foodLogImageView.layer.cornerRadius = 10;
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
    
    foodName = [foodName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
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
             
             instagramPicker.delegate = self;
             instagramPicker.imageURLArray = searchResults;
             
             [self.navigationController pushViewController:instagramPicker animated:YES];
             
             NSLog(@"%@", searchResults);
             
             
         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
             
         }];
    
}



-(void)foursquareRequestForRestaurantName:(NSString*)restaurantName {
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=VENOVOCEM4E1QVRTGNOCNO40V32YHQ4FMRD0M3K4WBMYQWPS&client_secret=QVM22AMEWXEZ54VBHMGOHYE2JNMMLTQYKOKOSAK0JTGDQBLT&v=20130815&query=%@&ll=%f,%f&radius=2000", restaurantName, self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:urlString
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
             NSLog(@"you are at %f and %f with %@", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude, responseObject);
             
             
         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
                NSLog(@"you are at %f and %f", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
             
         }];
    
    
    
    
}

#pragma mark - Image Picker Controller Delegate methods

- (IBAction)snapAPhotoButtonTapped:(UIButton *)sender {

    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (cameraDeviceAvailable && photoLibraryAvailable) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *takePhoto;
        UIAlertAction *choosePhoto;
        UIAlertAction *cancelFoodLogPhotoTaking;
        
        takePhoto = [UIAlertAction actionWithTitle:@"Take Photo"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [self shouldStartCameraController];
                                               }];
        choosePhoto = [UIAlertAction actionWithTitle:@"Choose Photo"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *action) {
                                                 [self shouldStartPhotoLibraryPickerController];
                                             }];
        
        cancelFoodLogPhotoTaking = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //NSLog(@"canceled");
        }];
        
        [alertController addAction:takePhoto];
        [alertController addAction:choosePhoto];
        [alertController addAction:cancelFoodLogPhotoTaking];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // if we don't have at least two options, we automatically show whichever is available (camera or roll)
        [self shouldPresentPhotoCaptureController];
    }
    
    
//    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    // imagePickerController.allowsEditing = YES;
//    [self presentViewController:self.imagePickerController animated:NO completion:nil];
//
//    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    
}

- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}


- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *foodPhotoImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.foodLogImageView.image = foodPhotoImage;
    self.foodLogImageView.layer.masksToBounds = YES;
    self.foodLogImageView.layer.cornerRadius = 10;
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        [self shouldStartPhotoLibraryPickerController];
    }
}


#pragma mark - search a pic on instagram method

- (IBAction)searchAPicOnInstagramButtonTapped:(UIButton *)sender {
    
    [self instagramRequestForTag:self.foodLogTitleTextField.text];
    [self foursquareRequestForRestaurantName:@"traif"];
}

#pragma mark - save image data to Parse 

- (void)saveImageDataToParseRemoteDatabase {
    
    UIImage *imageToBeSavedOnParse = self.foodLogImageView.image;
    
    // Convert to JPEG with 50% quality
    NSData* data = UIImageJPEGRepresentation(imageToBeSavedOnParse, 0.5f);
    PFFile *imageFileToBeSavedOnParse = [PFFile fileWithName:@"Image.jpg" data:data];
    
    // Save the image to Parse
    
    [imageFileToBeSavedOnParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            PFObject *foodLog = [PFObject objectWithClassName:@"FoodLog"];

            [foodLog setObject:imageFileToBeSavedOnParse forKey:@"image"];
            
            [foodLog saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}

#pragma mark - Save button 

- (void)saveButtonTapped {
//    
//    FDBLogData *aFoodLog = [FDBLogData object];
//    aFoodLog.foodLogDishTitle = self.foodLogTitleTextField.text;
//    
//    UIImage *foodLogImageToBeSaved = self.foodLogImageView.image;
//    NSData* data = UIImageJPEGRepresentation(foodLogImageToBeSaved, 0.5f);
//    aFoodLog.foodLogImageFile = [PFFile fileWithName:@"Image.jpg" data:data];
//    
////    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
//    }];
//    
//    [aFoodLog.foodLogImageFile  saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // The image has now been uploaded to Parse. Associate it with a new object
//            
//            [foodLog setObject:imageFileToBeSavedOnParse forKey:@"image"];
//            
//            [foodLog saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (!error) {
//                    //NSLog(@"Saved");
//                }
//                else{
//                    // Error
//                    NSLog(@"Error: %@ %@", error, [error userInfo]);
//                }
//            }];
//        }
//    }];
    
    
    
//    aFoodLog.foodLogImageTitle = ;
//    aFoodLog.foodLogRestaurantTitle = ;
//    aFoodLog.foodLogRecipeTitle =
//    aFoodLog.foodLogNotesText = ;
    
    
    UIImage *foodLogImageToBeSaved = self.foodLogImageView.image;
    
    // sending data to and storing in in Parse. This is a test version.
    PFObject *foodLog = [PFObject objectWithClassName:@"FoodLog"];
    foodLog[@"name"] = self.foodLogTitleTextField.text;
    
    // Convert to JPEG with 50% quality
    NSData* data = UIImageJPEGRepresentation(foodLogImageToBeSaved, 0.5f);
    PFFile *imageFileToBeSavedOnParse = [PFFile fileWithName:@"Image.jpg" data:data];
    
    // Save the image to Parse
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];

    [imageFileToBeSavedOnParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            
            [foodLog setObject:imageFileToBeSavedOnParse forKey:@"image"];
            
            [foodLog saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //NSLog(@"Saved");
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];


    
    //foodLog[@"notes"] = self.foodLogNotesTextField.text; // this property has not been created yet inside the VC
    [foodLog saveInBackground];
    
    UIImageWriteToSavedPhotosAlbum(foodLogImageToBeSaved, nil, nil, nil); // saves the snapped images to the camera roll on the device

    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark CoreLocation delegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    self.userLocation = crnLoc;
}

#pragma mark InstagramImagePickerDelegate

-(void)imagePickerDidSelectImageWithURL:(NSString *)url {
    
    [self.foodLogImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.foodLogImageView.image = image;
        
    }];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
      [textView setText:@""];
}

@end
