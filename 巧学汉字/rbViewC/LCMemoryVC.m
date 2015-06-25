//
//  LCMemoryVC.m
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCMemoryVC.h"
#import "LCCardView.h"
#import "CardView.h"
#import "UIColor+FlatColors.h"


@interface LCMemoryVC ()<LCCardSpinDelegate>
{
    BOOL isExplaned;//是否按钮已经展开
    int index;
    //移动卡时的缩放比例
    CGFloat bigVX ;
    CGFloat bigVY ;
    CGFloat rightVX;
    CGFloat rightVY;
    
    CGFloat bVX;
    CGFloat bVY;
    CGFloat rVX;
    CGFloat rVY;
    
    LCCardView * cardView1;//左边卡片
    LCCardView * cardView2;//中间卡片
    LCCardView * cardView3;//右边卡片1
    LCCardView * cardView4;//右边卡片2
    
    LCCoinHzView * primary;//汉字面
    LCCoinWordView * second;//词语面
    
    //data
    HanziDAO * hzDAO;
    NSArray * hzInfoArr;
}
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;

@end

@implementation LCMemoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //数据操作
   // hzDAO = [HanziDAO sharedManger];
   // hzInfoArr = [hzDAO hzDataReadGroupInfo:_hzGroupId];
    
    self.colorIndex = 0;
    self.colors = @[
                    @"Turquoise",
                    @"Green Sea",
                    @"Emerald",
                    @"Nephritis",
                    @"Peter River",
                    @"Belize Hole",
                    @"Amethyst",
                    @"Wisteria",
                    @"Wet Asphalt",
                    @"Midnight Blue",
                    @"Sun Flower",
                    @"Orange",
                    @"Carrot",
                    @"Pumpkin",
                    @"Alizarin",
                    @"Pomegranate",
                    @"Clouds",
                    @"Silver",
                    @"Concrete",
                    @"Asbestos"
                    ];
    //设置卡片
//    [self setCardView];
//    [self setCardCoinView:index];
    // Optional Delegate
    self.hzCardView.delegate = self;
    
}

- (void)viewDidLayoutSubviews {
    // Required Data Source
    self.hzCardView.dataSource = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  设置卡片数据
 *
 *  @param cardID 卡片ID
 */
-(void)setCardData:(NSInteger)cardID
           primary:(LCCoinHzView *)pri
            second:(LCCoinWordView *)sec
{
 
    HzDataInfo * hzInfo = [hzDAO hzDataReadOneInfo:cardID];//hzInfoArr[cardID];
    NSLog(@"\n------------------\n");
    [hzInfo dataDescription];
    NSLog(@"\n------------------\n");
    NSLog(@"pinyin = %@",hzInfo.pinyin);
    NSLog(@"hanzi = %@",hzInfo.hanzi);
    NSLog(@"word = %@",[hzDAO hzDataGetString:hzInfo.wordAddr size:hzInfo.wordSize]);
    //汉字
    pri.txtPinYin.text = hzInfo.pinyin;
    pri.txtHz.text = hzInfo.hanzi;
    //词语
    sec.txtWord.text= [hzDAO hzDataGetString:hzInfo.wordAddr size:hzInfo.wordSize];
    sec.imgWordPic.image  = [hzDAO hzDataGetImage:hzInfo.wordPicAddr size:hzInfo.wordPicSize];
    
}
-(void)setCoinView:(LCCardView*)cardView
{
    LCCoinHzView * primary1;//汉字面
    LCCoinWordView * second1;//词语面
    
    primary1 = [[NSBundle mainBundle]loadNibNamed:@"LCCoinHzView" owner:nil options:nil].firstObject;
    second1 = [[NSBundle mainBundle]loadNibNamed:@"LCCoinWordView" owner:nil options:nil].firstObject;
    
    [cardView setPrimaryView:primary1];
    [cardView setSecondaryView:second1];
    
    [self setCardData:index
              primary:primary1
               second:second1];
}
-(void)setCardCoinView:(NSInteger)cardId
{
     NSLog(@"\n cardId = %i\n",cardId);
    switch (cardId) {
        case 0:
            [self setCoinView:cardView2];
            break;
        case 1:
            [self setCoinView:cardView3];
            break;
        case 2:
            [self setCoinView:cardView4];
            break;
        case 3:
            [self setCoinView:cardView1];
            break;
        case 4:
            [self setCoinView:cardView2];
            break;
        case 5:
            [self setCoinView:cardView3];
            break;
        default:
            break;
    }
}
#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
          location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    if (self.colorIndex < self.colors.count)
    {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        view.backgroundColor = [self colorForName:self.colors[self.colorIndex]];
        self.colorIndex++;
        
     
        UIView *contentView =
        [[[NSBundle mainBundle] loadNibNamed:@"LCCoinWordView"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:contentView];
        
        // This is important:
        // https://github.com/zhxnlai/ZLSwipeableView/issues/9
        NSDictionary *metrics = @{
                                  @"height" : @(view.bounds.size.height),
                                  @"width" : @(view.bounds.size.width)
                                  };
        NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
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
- (UIColor *)colorForName:(NSString *)name
{
    NSString *sanitizedName =
    [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *selectorString =
    [NSString stringWithFormat:@"flat%@Color", sanitizedName];
    Class colorClass = [UIColor class];
    return [colorClass performSelector:NSSelectorFromString(selectorString)];
}
/**
 *  设置卡片
 */
-(void)setCardView
{
    //获取卡片
    cardView1 = (LCCardView *)[self.view viewWithTag:100];
    cardView2 = (LCCardView *)[self.view viewWithTag:101];
    cardView3 = (LCCardView *)[self.view viewWithTag:102];
    cardView4 = (LCCardView *)[self.view viewWithTag:103];
    //移动是缩放 比例
    bigVX   = cardView1.bounds.size.width /cardView2.bounds.size.width;
    bigVY   = cardView1.bounds.size.height/cardView2.bounds.size.height;
    rightVX = cardView2.bounds.size.width /cardView3.bounds.size.width;
    rightVY = cardView2.bounds.size.height/cardView3.bounds.size.height;
    
    bVX = cardView1.frame.origin.x -  cardView2.frame.origin.x;
    bVY = cardView1.frame.origin.y -  cardView2.frame.origin.y;
    rVX = cardView2.frame.origin.x -  cardView3.frame.origin.x;
    rVY = cardView2.frame.origin.y -  cardView3.frame.origin.y;
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
    
    
    if (index < 6) {
        [self setCardCoinView:index];
    }
}
/**
 *  练习
 *
 *  @param sender
 */
- (IBAction)onPractice:(id)sender {
    index++;
    [self animCardWithId:index];
}
/**
 *  移动卡片
 *
 *  @param moveID 移动的序号
 */
-(void)animCardWithId:(NSInteger)moveID
{
    switch (moveID) {
        case 1:
            [self animaTionCard:moveID leftV:cardView1 bigV:cardView2 rightV:cardView3 newV:cardView4];
            break;
        case 2:
            [self animaTionCard:moveID leftV:cardView2 bigV:cardView3 rightV:cardView4 newV:cardView1];
            break;
        case 3:
            [self animaTionCard:moveID leftV:cardView3 bigV:cardView4 rightV:cardView1 newV:cardView2];
            break;
        case 4:
            [self animaTionCard:moveID leftV:cardView4 bigV:cardView1 rightV:cardView2 newV:cardView3];
            break;
        case 5:
            [self animaTionCard:moveID leftV:cardView1 bigV:cardView2 rightV:cardView3 newV:cardView4];
            break;
        case 6:
            [self animaTionCard:moveID leftV:cardView2 bigV:cardView3 rightV:cardView4 newV:cardView1];
            break;
        default:
            break;
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
    [self explanMenu];
}

/**
 *  卡片移动结束
 *
 *  @param index 移动卡片的序号
 */
-(void)moveCardEnd:(NSInteger)moveID
{
//    [self setCardCoinView:moveID];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - private 
/**
 *  卡片移动动画
 *
 *  @param index 当前卡片序号
 */
-(void)animaTionCard:(NSInteger)moveID
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
    [UIView animateWithDuration:0.6 animations:^{
        rightV.transform = CGAffineTransformScale(rightV.transform,rightVX,rightVY);
        bigV.transform = CGAffineTransformScale(bigV.transform,bigVX,bigVY);
//        rightV.transform = CGAffineTransformMakeScale(rightVX,rightVY);
//        bigV.transform = CGAffineTransformMakeScale(bigVX,bigVY);
    }completion:^(BOOL finished) {
        [self moveCardEnd:moveID];
        
    }];
}
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
