//
//  InstagramImagePicker.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "InstagramImagePicker.h"

@implementation InstagramImagePicker

-(void)viewDidLoad{
    CGFloat leftAndRightPaddings = 32.0;
    CGFloat numberOfItemsPerRow = 3.0;
    CGFloat heightAdjustment = 30.0;
    
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - leftAndRightPaddings)/numberOfItemsPerRow;
    
    self.collectionViewLayout.itemSize = CGSizeMake(width, width +heightAdjustment)
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.imageURLArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestCell" forIndexPath:indexPath];
    
    
    
    return cell;
}


@end