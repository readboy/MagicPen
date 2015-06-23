//
//  HzStroke.m
//  MagicPen
//  汉字笔画
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "HzStroke.h"

@implementation HzStroke
{
     int strokeNum;
    NSMutableArray * strokeArr;
}
-(id)initHzStroke:(Byte *)byte
{
    if ([self init]) {
        strokeNum = [self readBuffer2Num:byte off:0x10 length:4];
        int offset = 0x18;
        Strokes * stroke;
        for (int i = 0; i < strokeNum; i++) {
            
            stroke = [[Strokes alloc]initStrokes:byte offset:offset];
            offset = [stroke getPointNum]* 2 + 6;
            
            [strokeArr addObject:stroke];
        }
    }
    return self;
}
-(int)getStrokeNum
{
    return strokeNum;
}
-(NSMutableArray *)getStrokes
{
    return strokeArr;
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
