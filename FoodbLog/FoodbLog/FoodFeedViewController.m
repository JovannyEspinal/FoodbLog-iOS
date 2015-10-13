//
//  FoodFeedViewController.m
//  FoodbLog
//
//  Created by Jovanny Espinal on 10/12/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import "FoodFeedViewController.h"
#import "FoodFeedCustomCVC.h"
#import <QuartzCore/QuartzCore.h>

@interface FoodFeedViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate>

    @property (nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FoodFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodFeedCustomCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    
    return cell;
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
