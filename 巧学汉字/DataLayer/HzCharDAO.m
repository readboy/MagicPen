//
//  HzCharDAO.m
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "HzCharDAO.h"

@implementation HzCharDAO
{
    NSInteger groupNum;

    NSArray* hzCharArr;
}

+(instancetype)sharedManger
{
    static dispatch_once_t once;
    static HzCharDAO *hzCharDAO;
    dispatch_once(&once, ^ {
        /**
         *  特别注意，要把文件加进来才可以
         *  Targets - > build pharses -> copy bundle resource ->添加文件*/
        hzCharDAO =  [[self alloc]initHzChar];
    });
    return hzCharDAO;
}
-(id)initHzChar
{
    if ([self init]) {
       
        NSString*path = [[NSBundle mainBundle] pathForResource:@"HzCharText" ofType:@"plist"];
        NSAssert(path != nil, @"汉字数据HzCharText.plist路径不存在！！");
        hzCharArr = [NSArray arrayWithContentsOfFile:path];
    }
    return self;
}
-(NSInteger)getGroupHz
{
    return [hzCharArr count];
}
-(NSArray*)getHzChar:(NSInteger) groupIndex
{
    NSMutableArray * hzArrM = [NSMutableArray array];;
    //云日月山水田
    NSString * charStr = hzCharArr[groupIndex];
    NSLog(@"charStr = %@",charStr);
    for (int i = 0; i < charStr.length; i++) {
        NSRange  range = NSMakeRange(i, 1);
        NSString * sub = [charStr substringWithRange:range];
        [hzArrM addObject:sub];
        
    }
    return hzArrM;
}
@end
