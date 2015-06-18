//
//  MyWorks.h
//  趣味画板
//
//  Created by readboy1 on 15/6/12.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWorks : UIView
@property (weak, nonatomic) IBOutlet UIImageView *worksContent;
@property (weak, nonatomic) IBOutlet UIButton *worksDel;
@property (weak, nonatomic) IBOutlet UIButton *worksSel;

- (IBAction)deleteWorks:(UIButton *)sender;
- (IBAction)selectWorks:(UIButton *)sender;

+ (id)myWorks;

+ (id)myWorksWithFrame:(CGRect)frame;

- (void)judgeWorksDelBtn:(BOOL)clickable;

@end
