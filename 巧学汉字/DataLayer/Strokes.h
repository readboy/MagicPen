//
//  Strokes.h
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Strokes : NSObject
/**
 *  初始化笔画
 *
 *  @param data   笔画数据
 *  @param offest 偏移
 *
 *  @return 笔画
 */
-(id)initStrokes:(Byte*)data offset:(int)offset;
/**
 *  笔画序号对应笔画读音
 *
 *  @return 笔画序号
 */
-(int)getStokeIndex;
/**
 *  笔画点数
 *
 *  @return 笔画点数
 */
-(int)getPointNum;
/**
 *  笔画点
 *
 *  @return 笔画点
 */
-(CGPoint*)getPoint;


@end
