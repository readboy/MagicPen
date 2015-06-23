//
//  HzDataInfo.h
//  MagicPen
//  汉字信息
//  Created by readboy2 on 15/6/19.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HzDataInfo : NSObject

@property (nonatomic,assign) int index;
@property (nonatomic,strong) NSString* hanzi;
@property (nonatomic,strong) NSString* pinyin;

@property (nonatomic,assign) int hzSndAddr;
@property (nonatomic,assign) int hzSndSize;

@property (nonatomic,assign) int wordAddr;
@property (nonatomic,assign) int wordSize;

@property (nonatomic,assign) int hzBhAddr;
@property (nonatomic,assign) int hzBhSize;

@property (nonatomic,assign) int wordSndAddr;
@property (nonatomic,assign) int wordSndSize;

@property (nonatomic,assign) int wordPicAddr;
@property (nonatomic,assign) int wordPicSize;

@property (nonatomic,assign) int sentAddr;
@property (nonatomic,assign) int sentSize;

@property (nonatomic,assign) int sentSndAddr;
@property (nonatomic,assign) int sentSndSize;

-(void)dataDescription;


@end
