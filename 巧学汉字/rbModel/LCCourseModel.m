//
//  LCCourseModel.m
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCCourseModel.h"
#import "HzCharDAO.h"
#import <UIKit/UIKit.h>

@implementation LCCourseModel
{
    NSArray* hzCharArr;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [[HzCharDAO sharedManger] getGroupHz];
}
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [[HzCharDAO sharedManger]getHzChar:[indexPath row]];
}
@end
