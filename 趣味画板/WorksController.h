//
//  WorksController.h
//  趣味画板
//
//  Created by readboy1 on 15/6/11.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorksController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *numTips;
@property (weak, nonatomic) IBOutlet UIView *worksPlace;

- (void)changeWorksNameArr:(NSArray *)worksArr;
- (void)setDataWithNameArr:(NSMutableArray *)worksName andWorksData:(NSMutableDictionary *)worksDataDic;

- (IBAction)btnClose:(UIButton *)sender;
- (IBAction)btnRecycle:(UIButton *)sender;
- (IBAction)btnLeft:(UIButton *)sender;
- (IBAction)btnRight:(UIButton *)sender;

@end
