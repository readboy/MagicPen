//
//  MyWorks.m
//  趣味画板
//
//  Created by readboy1 on 15/6/12.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import "MyWorks.h"

@implementation MyWorks
{
    SEL _selAction;
    SEL _delAction;
}

- (IBAction)deleteWorks:(UIButton *)sender {
    NSLog(@"deleteWorks:");
}

- (IBAction)selectWorks:(UIButton *)sender {
    NSLog(@"selectWorks:");
}

+ (id)myWorks {
    return [[NSBundle mainBundle] loadNibNamed:@"MyWorks" owner:nil options:nil][0];
}

+ (id)myWorksWithFrame:(CGRect)frame {
    
    MyWorks *works = [[NSBundle mainBundle] loadNibNamed:@"MyWorks" owner:nil options:nil][0];
    
    works.frame = frame;
    
    return works;
}

- (void)judgeWorksDelBtn:(BOOL)clickable {
    
    if (clickable) {
        [_worksDel setImage:[UIImage imageNamed:@"btn_del_nor.png"] forState:UIControlStateNormal];
    } else {
        [_worksDel setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    }
    
    _worksDel.enabled = clickable;
    _worksSel.enabled = !clickable;
}

@end
