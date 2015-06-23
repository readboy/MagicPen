//
//  LCMemoryVC.h
//  MagicPen
//  闪卡认字 视图控制器
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LearnChnieseBaseVC.h"
#import "LCCoinHzView.h"
#import "LCCoinWordView.h"

@interface LCMemoryVC : LearnChnieseBaseVC
@property (weak, nonatomic) IBOutlet UIButton *btnMemory;
@property (weak, nonatomic) IBOutlet UIButton *btnRead;
@property (weak, nonatomic) IBOutlet UIButton *btnPractice;
- (IBAction)onMemory:(id)sender;
- (IBAction)onRead:(id)sender;
- (IBAction)onPractice:(id)sender;

- (IBAction)onBack:(id)sender;
- (IBAction)onBigMemory:(id)sender;

@end
