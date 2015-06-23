//
//  HanziDAO.h
//  MagicPen
//  汉字信息操作类
//  Created by readboy2 on 15/6/19.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HzDataInfo.h"

@interface HanziDAO : NSObject

+(instancetype)sharedManger;

-(HzDataInfo*)hzDataReadOneInfo:(int)index;
@end
