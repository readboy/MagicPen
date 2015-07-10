//
//  LCMemoryModel.m
//  MagicPen
//  闪卡识字 model
//  Created by readboy2 on 15/6/25.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCMemoryModel.h"
@implementation LCMemoryModel
{
    AVAudioPlayer * dataSndPlay;
    HanziDAO * hzDAO;
    NSArray * hzInfoArr;
    BOOL isInit;
}

-(id)initMemoryModel:(int)hzGroupID
{
    self = [super init];
    if (self) {
        isInit = NO;
        dispatch_queue_t  dao = dispatch_queue_create("hzDataAccess", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        dispatch_async(dao, ^{
            hzDAO = [HanziDAO sharedManger];
            hzInfoArr = [hzDAO hzDataReadGroupInfo:hzGroupID];
            isInit = YES;

            dispatch_async(dispatch_get_main_queue(), ^{
                
              [[NSNotificationCenter defaultCenter] postNotificationName:HZDATA_INIT_FINISH_NOTIFTION
                                                                  object:nil];
            });
        });

    }
    return  self;
}
-(UIImage*)wordImageWithIndex:(int)hzIndex
{
    if (!isInit) {
        NSLog(@"数据还没初始化！！");
        return NO;
    }
    if (hzIndex >= hzInfoArr.count) {
        NSLog(@"序号错误，hzIndex = %d",hzIndex);
        return NO;
    }
    _hzIndex = hzIndex;
    HzDataInfo * hzInfo = hzInfoArr[hzIndex];

    return [hzDAO hzDataGetImage:hzInfo.wordPicAddr size:hzInfo.wordPicSize];
}
-(NSString*)hzPinYinWithIndex:(int)hzIndex
{
    if (!isInit) {
        NSLog(@"数据还没初始化！！");
        return NO;
    }
    if (hzIndex >= hzInfoArr.count) {
        NSLog(@"序号错误，hzIndex = %d",hzIndex);
        return nil;
    }
    _hzIndex = hzIndex;
    
    HzDataInfo * hzInfo = hzInfoArr[hzIndex];
    return hzInfo.pinyin;
}
-(NSString*)hzWithIndex:(int)hzIndex
{
    if (!isInit) {
        NSLog(@"数据还没初始化！！");
        return NO;
    }
    if (hzIndex >= hzInfoArr.count) {
        NSLog(@"序号错误，hzIndex = %d",hzIndex);
        return nil;
    }
    _hzIndex = hzIndex;
    HzDataInfo * hzInfo = hzInfoArr[hzIndex];
    
    return hzInfo.hanzi;
}
-(NSString*)wordWithIndex:(int)hzIndex
{
    if (hzIndex >= hzInfoArr.count) {
        NSLog(@"序号错误，hzIndex = %d",hzIndex);
        return nil;
    }
    _hzIndex = hzIndex;
    HzDataInfo * hzInfo = hzInfoArr[hzIndex];
    return [hzDAO hzDataGetString:hzInfo.wordAddr size:hzInfo.wordSize];;
}

-(BOOL)playWordSndWithIndex:(int)hzIndex
{
    if (!isInit) {
        NSLog(@"数据还没初始化！！");
        return NO;
    }
    NSLog(@"playWordSndWithIndex,hzIndex = %d",hzIndex);
    if (hzIndex >= hzInfoArr.count) {
        NSLog(@"序号错误，hzIndex = %d",hzIndex);
        return NO;
    }
    _isWord = YES;
    _hzIndex = hzIndex;
    HzDataInfo * hzInfo = hzInfoArr[hzIndex];

    
    NSData * sndData = [hzDAO hzDataGetSnd:hzInfo.wordSndAddr size:hzInfo.wordSndSize];
    return [self playSnd:sndData];
}
-(BOOL)playHzSndWithIndex:(int)hzIndex
{
    if (!isInit) {
        NSLog(@"数据还没初始化！！");
        return NO;
    }
    NSLog(@"playHzSndWithIndex,hzIndex = %d",hzIndex);
    if (hzIndex >= hzInfoArr.count) {
        NSLog(@"序号错误，hzIndex = %d",hzIndex);
        return NO;
    }
    _isWord = NO;
    _hzIndex = hzIndex;
    
    HzDataInfo * hzInfo = hzInfoArr[hzIndex];

    NSData * sndData = [hzDAO hzDataGetSnd:hzInfo.hzSndAddr size:hzInfo.hzSndSize];
    return [self playSnd:sndData];
}
/**
 *  播放语音
 *
 *  @param sndData 语音数据
 */
-(BOOL)playSnd:(NSData*)sndData
{

    NSError * err;
    dataSndPlay = [[AVAudioPlayer alloc] initWithData:sndData error:&err];
    NSLog(@"err %@", err);
    if (err) {
        return NO;
    }
    dataSndPlay.delegate = self;
    
    [dataSndPlay prepareToPlay];
    
    [dataSndPlay play];
    
    return YES;
   
}
#pragma mark - AVAudioPlayer代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //self.playFinish(YES ,_hzIndex,_isWord);
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    
}
@end
