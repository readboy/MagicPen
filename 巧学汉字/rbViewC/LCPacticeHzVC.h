//
//  LCPacticeHzVC.h
//  MagicPen
//  巩固练习 听音辩字
//  Created by readboy2 on 15/6/25.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LearnChnieseBaseVC.h"
#import  "LCBubbleContainerView.h"

@interface LCPacticeHzVC : LearnChnieseBaseVC<BubbleViewDataSource>

@property (weak, nonatomic) IBOutlet LCBubbleContainerView *bubbleContainerView;
@end
