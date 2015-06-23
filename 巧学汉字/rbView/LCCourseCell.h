//
//  LCCourseCell.h
//  MagicPen
//
//  Created by readboy2 on 15/6/19.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *courseItemBgView;
@property (weak, nonatomic) IBOutlet UILabel *courseItemLabel;
@property (assign,nonatomic) BOOL isSelectedIndex;


- (BOOL)shouldUpdateCellWithObject:(id)object
                       atIndexPath:(NSIndexPath *)indexPath;
@end
