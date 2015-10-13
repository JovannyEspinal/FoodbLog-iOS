//
//  InstagramImagePicker.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "InstagramImagePicker.h"
#import "FoodImagePickerCustomCVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation InstagramImagePicker

-(void)viewDidLoad{
    CGFloat leftAndRightPaddings = 32.0;
    CGFloat numberOfItemsPerRow = 3.0;
    CGFloat heightAdjustment = 30.0;
    
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - leftAndRightPaddings)/numberOfItemsPerRow;
    
    UICollectionViewFlowLayout *layout = self.collectionViewLayout;
    layout.itemSize = CGSizeMake(width, width +heightAdjustment);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FoodImagePickerCustomCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodImagePickerCell" forIndexPath:indexPath];
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    //CHANGE cell.foodImage.image to the converted imageURL from the imageURLArray
    
    
    return cell;
}


@end
