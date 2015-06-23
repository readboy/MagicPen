//
//  LCMemoryVC.m
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCMemoryVC.h"
#import "LCCardView.h"

@interface LCMemoryVC ()<LCCardSpinDelegate>
{
    BOOL isExplaned;//是否按钮已经展开
    BOOL index;
    CGFloat bigVX ;
    CGFloat bigVY ;
    CGFloat rightVX ;
    CGFloat rightVY ;
    CGRect rightVRECTL;
    CGRect bigVRECT;
    LCCardView * coinBigv;
    UIView * lv ;
    UIView * bv ;
    UIView * rv1;
    UIView * rv2;
}
@end

@implementation LCMemoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lv = [self.view viewWithTag:100];
    bv = [self.view viewWithTag:101];
    rv1 = [self.view viewWithTag:102];
    rv2 = [self.view viewWithTag:103];
    coinBigv = (LCCardView *)[self.view viewWithTag:101];

    LCCoinHzView * primary = [[NSBundle mainBundle]loadNibNamed:@"LCCoinHzView" owner:nil options:nil].lastObject;
    LCCoinWordView * second = [[NSBundle mainBundle]loadNibNamed:@"LCCoinWordView" owner:nil options:nil].lastObject;
    
    [coinBigv setPrimaryView:primary];
    [coinBigv setSecondaryView:second];
    

    
    bigVX = lv.bounds.size.width/bv.bounds.size.width;
    bigVY =lv.bounds.size.height/bv.bounds.size.height;
    rightVX = bv.bounds.size.width/rv1.bounds.size.width;
    rightVY =bv.bounds.size.height/rv1.bounds.size.height;
    NSLog(@"bigVX = %f,bigVY = %f,rightVX =%f,rightVY = %f",bigVX,bigVY,rightVX,rightVY);
    rightVRECTL = lv.bounds;
    bigVRECT = bv.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  闪卡识字
 *
 *  @param sender
 */
- (IBAction)onMemory:(id)sender {
}
/**
 *  跟读
 *
 *  @param sender
 */
- (IBAction)onRead:(id)sender {
   // [coinBigv flipTouched];
}
/**
 *  练习
 *
 *  @param sender
 */
- (IBAction)onPractice:(id)sender {
    
    if (++index < 6) {
        if (index == 1) {
           [self animaTionCard:0 leftV:lv bigV:bv rightV:rv1 newV:rv2];
        }else if (index == 2){
           [self animaTionCard:0 leftV:bv bigV:rv1 rightV:rv2 newV:lv];
        }else if (index == 3){
            [self animaTionCard:0 leftV:rv1 bigV:rv2 rightV:lv newV:bv];
        }else if (index == 4){
            [self animaTionCard:0 leftV:rv2 bigV:lv rightV:bv newV:rv1];
        }else if (index == 5){
            [self animaTionCard:0 leftV:lv bigV:bv rightV:rv1 newV:rv2];
        }else if (index == 6){
            [self animaTionCard:0 leftV:bv bigV:rv1 rightV:rv2 newV:lv];
        }
    }
    
}
/**
 *  返回
 *
 *  @param sender
 */
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 *  点击到 大的闪卡识字
 *
 *  @param sender
 */
- (IBAction)onBigMemory:(id)sender {
    if (isExplaned) {
        //动画
        [UIView animateWithDuration:0.3f animations:^{
            _btnMemory.transform = CGAffineTransformIdentity;
            _btnRead.transform = CGAffineTransformIdentity;
            _btnPractice.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            isExplaned = NO;
        }];
    }else{
        //动画
        [UIView animateWithDuration:0.3f animations:^{
            _btnMemory.transform = CGAffineTransformMakeTranslation(50.f, -20);
            _btnRead.transform = CGAffineTransformMakeTranslation(50.f, 40.f);
            _btnPractice.transform = CGAffineTransformMakeTranslation(0, 60.f);
        } completion:^(BOOL finished) {
            isExplaned = YES;
        }];
    }
}
/**
 *  卡片移动动画
 *
 *  @param index 当前卡片序号
 */
-(void)animaTionCard:(NSInteger)index
               leftV:(UIView *)leftV
                bigV:(UIView *)bigV
              rightV:(UIView *)rightV
                newV:(UIView *)newV
{
    
    CGPoint center1 = bigV.center;
    CGPoint center2 = leftV.center;
    newV.alpha = 0.0f;

    [UIView animateWithDuration:0.5f animations:^{
    
        bigV.center = center2;
        rightV.center = center1;
        leftV.alpha = 0.0;
        newV.alpha = 1.0f;
    } completion:^(BOOL finished) {
        leftV.center = newV.center;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        rightV.transform = CGAffineTransformScale(rightV.transform,rightVX,rightVY);
        bigV.transform = CGAffineTransformScale(bigV.transform,bigVX,bigVY);
    }completion:^(BOOL finished) {

        
    }];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
