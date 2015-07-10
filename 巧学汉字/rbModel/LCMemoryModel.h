//
//  LCMemoryModel.h
//  MagicPen
//
//  Created by readboy2 on 15/6/25.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HanziDAO.h"

#define HZDATA_INIT_FINISH_NOTIFTION @"LCHZDATAINITFINISH" //汉字数据初始化完成通知。

typedef void(^avPlayFinish)(BOOL isFnish ,int hzIndex,BOOL isWord);

@interface LCMemoryModel : NSObject<AVAudioPlayerDelegate>

@property (nonatomic,strong) avPlayFinish playFinish;
@property (nonatomic,assign) int hzIndex;
@property (nonatomic,assign) BOOL isWord;

-(id)initMemoryModel:(int)hzGroupID;

-(UIImage*)wordImageWithIndex:(int)hzIndex;
-(NSString*)hzPinYinWithIndex:(int)hzIndex;
-(NSString*)hzWithIndex:(int)hzIndex;
-(NSString*)wordWithIndex:(int)hzIndex;

-(BOOL)playWordSndWithIndex:(int)hzIndex;
-(BOOL)playHzSndWithIndex:(int)hzIndex;


@end
