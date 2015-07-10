//
//  SoundWaveComAir.h
//  SoundWaveComAir
//
//  Created by readboy2 on 15/6/17.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int (*DecodeUserCallBack) (int i32Commnad);
#define kComAirUserCallBack @"ComAirUserCallBack"
typedef void(^UserCallBack)(int command);


@interface SoundWaveComAir : NSObject

+(instancetype)sharedManger;
/**
 *  振动笔
 *
 *  @return
 */
-(bool)vibratePen;
-(bool)commandDecode:(DecodeUserCallBack)callBack;

-(BOOL)stopDecode;
-(BOOL)relaseComAir;

@end
