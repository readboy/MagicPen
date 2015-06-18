//
//  MyCanvas.h
//  趣味画板
//
//  Created by readboy1 on 15/6/8.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCanvas : UIView
{
    CGContextRef _context;
    // 原有笔画
    NSMutableArray *_strokesArr;
    // 新添加笔画
    NSMutableArray *_strokeNewPoints;
    // 笔刷颜色
    UIColor *_curColor;
    // 笔刷大小
    float _curSize;
    // 判断是否正在使用笔刷
    BOOL _isPalette;
    // 判断画板内容是否有所变更
    BOOL *_isChange;
}

- (void)changeCurWidthWithSize:(float)size;

- (void)changeCurColorWithColor:(UIColor *)color;

- (void)changeColorAlphaWithValue:(CGFloat)alpha;

- (UIImageView *)createItemWithTag:(NSInteger)tag;

- (void)changeToPalette:(BOOL)judge;

- (BOOL)backAboutChange;

- (NSMutableDictionary *)saveCurData;

- (void)recoverDataWithDic:(NSDictionary *)dic;

@end
