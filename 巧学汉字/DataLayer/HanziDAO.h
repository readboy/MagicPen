//
//  HanziDAO.h
//  MagicPen
//  汉字信息操作类
//  Created by readboy2 on 15/6/19.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HzDataInfo.h"
#import "HzStroke.h"

@interface HanziDAO : NSObject
/**
 *  单实例类
 *
 *  @return 实例对象
 */
+(instancetype)sharedManger;
/**
 *  退出
 */
-(void)hzDataExit;
/**
 *  获取汉字的个数
 *
 *  @return 汉字个数
 */
-(int)hzDataGetHzNum;
/**
 *  获取当个汉字信息
 *
 *  @param index 汉字序号
 *
 *  @return 汉字信息
 */
-(HzDataInfo*)hzDataReadOneInfo:(int)index;


/**
 * 读取一组汉字信息
 *
 * @param groupIndex 组的序号
 * @return 汉字信息
 */
-(NSArray*)hzDataReadGroupInfo:(int)groupIndex;
/**
 *  获取 image
 *
 *  @param addr image 地址
 *  @param size image 大小
 *
 *  @return image
 */
-(UIImage*)hzDataGetImage:(int)addr size:(int)size;
/**
 *  获取语音的 Data
 *
 *  @param addr 语音数据地址
 *  @param size 大小
 *
 *  @return 语音DATA
 */
-(NSData*)hzDataGetSnd:(int)addr size:(int)size;
/**
 * 句子需要拆分
 *
 * 天上|飘着|几朵白云。
 * @param addr
 * @param size
 * @return  词语
 */
-(NSArray*)hzDataGetSentence:(int )addr size:(int) size;
/**
 *  获取词语（获取字符串）
 *
 *  @param addr 词语的地址
 *  @param size 词语的大小
 *
 *  @return 词语
 */
-(NSString*)hzDataGetString:(int)addr  size:(int) size;
/**
 * 笔画信息
 *
 * @param addr
 * @param size
 * @return 笔画
 */
-(HzStroke*)hzDataGetBihua:(int)addr size:(int)size;

@end
