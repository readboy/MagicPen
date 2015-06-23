//
//  LCCourseCell.m
//  MagicPen
//
//  Created by readboy2 on 15/6/19.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCCourseCell.h"

@implementation LCCourseCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)shouldUpdateCellWithObject:(id)object
                       atIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arr = (NSArray*)object;
    NSString * courseTxt = [NSString stringWithFormat:@"第%d课：",indexPath.row +1];
    for (NSString* hz in arr) {
        courseTxt = [courseTxt stringByAppendingString:hz];
        courseTxt = [courseTxt stringByAppendingString:@"  "];
    }
   
    _courseItemLabel.text = courseTxt;
    
    return YES;
}
@end
