//
//  FoodbLog.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/12/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "FoodbLog.h"
#import "FoodbLogCustomHeader.h"
#import "FoodbLogCustomCVC.h"
#import <QuartzCore/QuartzCore.h>

@interface FoodbLog () <UICollectionViewDataSource, UICollectionViewDelegate>


@end

@implementation FoodbLog

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat leftAndRightPaddings = 32.0;
    CGFloat numberOfItemsPerRow = 3.0;
    CGFloat heightAdjustment = 30.0;
    
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - leftAndRightPaddings)/numberOfItemsPerRow;
    
    UICollectionViewFlowLayout *layout = self.collectionViewLayout;
    layout.itemSize = CGSizeMake(width, width +heightAdjustment);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodbLogCustomCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodbLogCell" forIndexPath:indexPath];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    FoodbLogCustomHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"foodbLogHeaderView" forIndexPath:indexPath];
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        
        if (indexPath.section == 0) {
    
            headerView.foodbLogHeaderLabel.text = @"Food" ;
        } else {
            headerView.foodbLogHeaderLabel.text = @"Recipes";
        }
    }
    
    return headerView;
    
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
