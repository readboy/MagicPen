//
//  Strokes.m
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "Strokes.h"


@implementation Strokes
{
     int strokeIndex;//笔画序号
     int pointNum;   //笔画点的总数
     CGPoint *point; //笔画 点的坐标
}
-(id)initStrokes:(Byte*)data offset:(int)offset
{
    if ([self init]) {
        strokeIndex = (data[offset] & 0xff);
        pointNum = [self readBuffer2Num:data off:offset + 1 length:2];
        for (int i = 0; pointNum; i++) {
            point[i].x =  (data[offset + 4 + i * 2] & 0xff);
            point[i].y =  (data[offset + 4 + i * 2 + 1] & 0xff);
        }
    }
    return self;
}
-(int)getStokeIndex
{
    return strokeIndex;
}
-(int)getPointNum
{
    return pointNum;
}
-(CGPoint*)getPoint
{
    return point;
}


#pragma mark private
-(int)readBuffer2Num:(Byte*) buff
                 off:(int)off
              length:(int)n
{
    int num = 0;
    int index = off + (n - 1);
    
    while ((n--) > 0) {
        num <<= 8;
        NSLog(@"buff[%d] = %x",index,buff[index]);
        num += buff[index] & 0xff;
        index--;
    }
    NSLog(@"readBuffer2Num, num = %d",num);
    return num;
}
@end
