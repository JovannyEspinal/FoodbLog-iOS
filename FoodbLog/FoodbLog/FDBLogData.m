//
//  FDBLogData.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/15/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//
#import <Parse/PFObject+Subclass.h>

#import "FDBLogData.h"

@implementation FDBLogData
@synthesize aFoodLog;

@dynamic foodLogDishTitle;
@dynamic foodLogImageFile;
@dynamic foodLogImageTitle;
@dynamic foodLogRestaurantTitle;
@dynamic foodLogRecipeTitle;
@dynamic foodLogNotesText;
+ (NSString *)FoodLog {
    return @"FDBLogData";
}



@end
