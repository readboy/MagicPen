//
//  LCBubbleContainerView.h
//  MagicPen
//  气泡容器类
//  Created by readboy2 on 15/6/25.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagicHeader.h"
#import "BubbleView.h"

@class LCBubbleContainerView;

/**
 *  气泡容器数据源协议
 */
@protocol BubbleViewDataSource <NSObject>

@required
//气泡View
- (UIView *)bubbleView:(LCBubbleContainerView *)bubbleContainerView;
//气泡的个数
- (int)bubbleNumber:(LCBubbleContainerView *)bubbleContainerView;

@end
@protocol BubbleViewViewDelegate <NSObject>

@optional
//气泡运动到容器上边缘
-(void)bubbleUp:(int)bubbleViewID;
//气泡运动到容器下边缘
-(void)bubbleDown:(int)bubbleViewID;
//气泡运动到容器左边缘
-(void)bubbleLeft:(int)bubbleViewID;
//气泡运动到容器右边缘
-(void)bubbleRight:(int)bubbleViewID;



@end



@interface LCBubbleContainerView : UIView

@property (nonatomic, weak)  id<BubbleViewDataSource> dataSource;
@property (nonatomic, weak)  id<BubbleViewViewDelegate> delegate;


@property (nonatomic,assign) BOOL isCanOverlap;//气泡运动过程中是否能重叠
@property (nonatomic,assign) int  sleepTime;//气泡运动的速率

@end
