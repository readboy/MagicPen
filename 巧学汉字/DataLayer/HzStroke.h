//
//  HzStroke.h
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Strokes.h"

@interface HzStroke : NSObject
/**
 *  初始化笔
 *
 *  @param byte 笔画数据
 *
 *  @return 笔画
 */
-(id)initHzStroke:(Byte*)byte;
/**
 *  笔画数
 *
 *  @return 笔画数
 */
-(int)getStrokeNum;
/**
 *  笔画
 *
 *  @return 笔画
 */
-(NSMutableArray*)getStrokes;
@end
