//
//  SoundWaveComAir.m
//  SoundWaveComAir
//
//  Created by readboy2 on 15/6/17.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "SoundWaveComAir.h"

#import "Include/ComAirAPI_V1.1.1.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#define kComAirUserCallBack @"ComAirUserCallBack"
typedef void(^UserCallBack)(int command);

@implementation SoundWaveComAir
{
    UserCallBack userCallBack;
}

+(instancetype)sharedManger
{
    static dispatch_once_t once;
    static SoundWaveComAir *comAir;
    dispatch_once(&once, ^ {
        comAir = [[self alloc] initComAir];
    });
    return comAir;
}
/**
 *  初始化
 *
 *  @return self
 */
-(id)initComAir
{
    if ([self init]) {
        //route audio output to speaker
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
        
        //初始化COMAIR
        InitComAirAudio();
        
        //设置解码模式
        SetComAirDecodeMode(eDecodeMode_05Sec);
        //设置编码模式
        SetComAirEncodeMode(eEncodeMode_05Sec);
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notifyCallBack:)
                                                    name:kComAirUserCallBack
                                                  object:nil];
    }
    return self;
}
-(void)notifyCallBack:(NSNotification*)notify
{
    NSLog(@"notifyCallBack");
    
    NSDictionary * dic = [notify userInfo];
    int command = [[dic objectForKey:kComAirUserCallBack] integerValue];
    
    userCallBack(command);
}
-(bool)playSoundNumber:(int)Number
{
    NSString *SoundIndex = [[NSString alloc]initWithFormat:@"n%d",Number];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: SoundIndex ofType: @"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    PlaySoundWithComAirCmd(fileURL,1,Number);
    
    return true;
}
-(bool)	playNumber:(int)Number
           fileURL:(NSURL*) fileURL
{

    PlayComAirCmd(7,1.0);
    return true;
}
-(bool)startDecode:(UserCallBack)callBack
{
    userCallBack = callBack;
    //设置回调
    SetComAirUserCallBack(&ComAirUserCallBack);
    
    StartComAirDecode();
    return true;
}
int ComAirUserCallBack(int Command)
{
    NSLog(@"ComAirUserCallBack:Command  =%i",Command);
    NSDictionary * dic = [NSDictionary dictionary];
    [dic setValue:[NSNumber numberWithInt:Command] forKey:kComAirUserCallBack];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kComAirUserCallBack
                                                        object:nil
                                                      userInfo:dic];
    return 0;
}
#pragma Public
-(bool)vibratePen
{
    //7 表示振动
    PlayComAirCmd(7,1.0);
    
    return true;
}
-(bool)commandDecode:(DecodeUserCallBack)callBack
{
    //设置回调
    SetComAirUserCallBack(callBack);
    StartComAirDecode();
    
    return true;
}
-(BOOL)stopDecode
{
    StopComAirDecode();
    
    return YES;
}
-(BOOL)relaseComAir
{
    UnitComAirAudio();
    
    return YES;
}

@end
