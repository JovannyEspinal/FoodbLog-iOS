//
//  InstagramImagePicker.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "InstagramImagePicker.h"
#import "FoodImagePickerCustomCVC.h"
#import "InstagramPickerDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

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
    
    return [self.imageURLArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FoodImagePickerCustomCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodImagePickerCell" forIndexPath:indexPath];
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    [cell.foodImage sd_setImageWithURL:[NSURL URLWithString:self.imageURLArray[indexPath.row]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.foodImage.image = image;
    }];

    
    
    return cell;
}


@end
