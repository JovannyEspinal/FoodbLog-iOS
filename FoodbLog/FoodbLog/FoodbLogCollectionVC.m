//
//  FoodbLog.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/12/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#import "FoodbLogCollectionVC.h"
#import "FoodbLogCustomHeader.h"
#import "FoodbLogCustomCell.h"
#import "FoodLog.h"

@interface FoodbLogCollectionVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *allFoodLogObjects;

@end

@implementation FoodbLogCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat leftAndRightPaddings = 32.0;
    CGFloat numberOfItemsPerRow = 3.0;
    CGFloat heightAdjustment = 30.0;
    
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - leftAndRightPaddings)/numberOfItemsPerRow;
    
    UICollectionViewFlowLayout *layout = self.collectionViewLayout;
    layout.itemSize = CGSizeMake(width, width +heightAdjustment);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self pullDataFromParse];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.allFoodLogObjects.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodbLogCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodbLogCell" forIndexPath:indexPath];
    
    FoodLog *log = self.allFoodLogObjects[indexPath.row];
    cell.foodbLogImageInTheFoodbLogCell.file = log.image;
    [cell.foodbLogImageInTheFoodbLogCell loadInBackground];
    
    cell.layer.masksToBounds = YES;

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

#pragma mark - Parse methods

- (void)pullDataFromParse {
    
    PFQuery *query = [PFQuery queryWithClassName:[FoodLog parseClassName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.allFoodLogObjects = objects;
        [self.collectionView reloadData];
    }];
    
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
