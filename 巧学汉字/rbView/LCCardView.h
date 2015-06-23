//
//  LCCardView.h
//  MagicPen
//  卡片View
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCoinHzView.h"
#import "LCCoinWordView.h"
//卡片翻转代理
@protocol LCCardSpinDelegate <NSObject>

@optional
/**
 *  开始翻转卡片
 *
 *  @param index  翻转序号，每翻转一次 加 1
 *  @param cardId 卡片序号
 */
-(void)startSpinCard:(NSInteger)index cardID:(NSInteger)cardId;
/**
 *  翻转卡片 结束
 *
 *  @param index  翻转序号，每翻转一次 加 1
 *  @param cardId 卡片序号
 */
-(void)endSpinCard:(NSInteger)index cardID:(NSInteger)cardId;
@end

@interface LCCardView : UIView
//卡片第一个界面 ：汉字
@property (nonatomic, retain) LCCoinHzView *primaryView;
//卡片第二个界面 ：词语
@property (nonatomic, retain) LCCoinWordView *secondaryView;
//代理
@property (nonatomic, strong) id<LCCardSpinDelegate> delegate;
//卡片 ID
@property (nonatomic, assign) NSInteger cardID;
/**
 *  翻转卡片
 */
-(void)spinCard;
@end
