//
//  LCBaseModel.h
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCModelDelegate  <NSObject>

@optional
+ (instancetype)sharedViewModel;
//总的数据个数
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface LCBaseModel : NSObject<LCModelDelegate>

@end
