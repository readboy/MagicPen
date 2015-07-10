//
//  LCMemoryVC.m
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCMemoryVC.h"
#import "CardView.h"
#import "LCMemoryModel.h"
#define CARDNUM  12
#define TAGMIN  100


@interface LCMemoryVC ()
{
    BOOL isExplaned;//是否按钮已经展开
    int index;
}

@property (nonatomic,assign) NSUInteger cardIndex;
@property (nonatomic,strong) LCMemoryModel * memoryModel;

@end

@implementation LCMemoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cardIndex = 0;
    //设置卡片
    // Optional Delegate
    self.hzCardView.delegate = self;
    
    //初始化model
    _memoryModel = [[LCMemoryModel alloc]initMemoryModel:_hzGroupId];
    
    //数据加载广播
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hzDataInitCompletion)
                                                 name:HZDATA_INIT_FINISH_NOTIFTION
                                               object:nil];
}
/**
 *  数据加载成功。
 */
-(void)hzDataInitCompletion
{
    //播放第一个 汉字的读音
    [_memoryModel playHzSndWithIndex:0];
    
    self.cardIndex = 0;
    [self.hzCardView discardAllSwipeableViews];
    [self.hzCardView loadNextSwipeableViewsIfNeeded];
}
- (void)viewDidLayoutSubviews
{
    // Required Data Source
    self.hzCardView.dataSource = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZLSwipeableViewDelegate
//卡片移动结束
- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
    int cardId = view.tag - TAGMIN;
    //播放第一个 汉字的读音
    if (cardId %2) {
        [_memoryModel playHzSndWithIndex:cardId/2 + 1];
    }else{
        [_memoryModel playWordSndWithIndex:cardId/2];
    }
  
}
#pragma ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    if (self.cardIndex < CARDNUM)
    {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        //设置卡片的TAG
        [view setTag:TAGMIN + self.cardIndex];
        
        self.cardIndex++;
 
        NSDictionary *views;
        if (self.cardIndex %2) {
            LCCoinHzView *contentView;
            contentView = [[[NSBundle mainBundle] loadNibNamed:@"LCCoinHzView"
                                           owner:self
                                         options:nil] objectAtIndex:0];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:contentView];
            views = NSDictionaryOfVariableBindings(contentView);
            contentView.txtHz.text = [_memoryModel hzWithIndex:self.cardIndex/2];
            contentView.txtPinYin.text = [_memoryModel hzPinYinWithIndex:self.cardIndex/2];
            
        }else{
            LCCoinWordView *contentView;
            contentView = [[[NSBundle mainBundle] loadNibNamed:@"LCCoinWordView"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
            
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:contentView];
             views = NSDictionaryOfVariableBindings(contentView);
            contentView.txtWord.text = [_memoryModel wordWithIndex:(self.cardIndex -1)/2];
            contentView.imgWordPic.image = [_memoryModel wordImageWithIndex:(self.cardIndex-1)/2];
        }
         

        // This is important:
        // https://github.com/zhxnlai/ZLSwipeableView/issues/9
        NSDictionary *metrics = @{
                                  @"height" : @(view.bounds.size.height),
                                  @"width" : @(view.bounds.size.width)
                                  };
  
        [view addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[contentView(width)]"
          options:0
          metrics:metrics
          views:views]];
        [view addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:
                              @"V:|[contentView(height)]"
                              options:0
                              metrics:metrics
                              views:views]];
          return view;
    }
    
    return nil;
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

}
/**
 *  练习
 *
 *  @param sender
 */
- (IBAction)onPractice:(id)sender {

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
    [self explanMenu];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - private 

/**
 *  展开 按钮菜单
 */
-(void)explanMenu
{
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
@end
