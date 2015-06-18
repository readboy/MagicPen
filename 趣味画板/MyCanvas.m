//
//  MyCanvas.m
//  趣味画板
//
//  Created by readboy1 on 15/6/8.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import "MyCanvas.h"

@implementation MyCanvas

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _strokesArr = [[NSMutableArray alloc] init];
        // 笔刷初始大小为1.0
        _curSize = 1.0;
        // 笔刷初始颜色为黑色
        _curColor = [UIColor blackColor];
        // 设置背景为透明色
        self.backgroundColor = [UIColor clearColor];
    }    return self;
}

- (void)drawRect:(CGRect)rect {
    if ((!_strokeNewPoints) || (_strokeNewPoints.count < 1)) {
        return;
    }
    
    _context = UIGraphicsGetCurrentContext();
    // 设置线条终点形状为圆形
    CGContextSetLineCap(_context, kCGLineCapRound);
    
    // 恢复旧笔画
    for (NSDictionary *strokeDic in _strokesArr) {
        // 旧笔画属性和点
        UIColor *strColor = [strokeDic objectForKey:@"color"];
        float strSize = [[strokeDic objectForKey:@"size"] floatValue];
        NSArray *strPoints = [strokeDic objectForKey:@"points"];
        
        CGContextSetLineWidth(_context, strSize);
        CGContextSetStrokeColorWithColor(_context, [strColor CGColor]);
        
        // 实现画笔
        for (int i = 0; i < (strPoints.count - 1); i++) {
            CGPoint point1 = [[strPoints objectAtIndex:i] CGPointValue];
            
            CGPoint point2 = [[strPoints objectAtIndex:(i+1)] CGPointValue];
            
            CGContextMoveToPoint(_context, point1.x, point1.y);
            
            CGContextAddLineToPoint(_context, point2.x, point2.y);
            
            CGContextStrokePath(_context);
        }
    }
    
    // 添加新笔画
    CGContextSetLineWidth(_context, _curSize);
    CGContextSetStrokeColorWithColor(_context, [_curColor CGColor]);
    for (int i = 0; i < (_strokeNewPoints.count - 1); i++) {
        CGPoint point1 = [[_strokeNewPoints objectAtIndex:i] CGPointValue];
        
        CGPoint point2 = [[_strokeNewPoints objectAtIndex:(i+1)] CGPointValue];
        
        CGContextMoveToPoint(_context, point1.x, point1.y);
        
        CGContextAddLineToPoint(_context, point2.x, point2.y);
        
        CGContextStrokePath(_context);
    }
}

- (BOOL)isMultipleTouchEnabled {
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_isPalette) {
        _strokeNewPoints = [[NSMutableArray alloc] init];
    
        CGPoint curPoint = [[touches anyObject] locationInView:self];
    
        [_strokeNewPoints addObject:[NSValue valueWithCGPoint:curPoint]];
    
        // 把touchesMoved:方法添加进来,为了实现点击有效
        [self touchesMoved:touches withEvent:event];
        
    } else {
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_isPalette) {
        CGPoint curPoint = [[touches anyObject] locationInView:self];
    
        [_strokeNewPoints addObject:[NSValue valueWithCGPoint:curPoint]];
    
        [self setNeedsDisplay];
        
    } else {
        NSLog(@"???");
        CGPoint curPoint = [[touches anyObject] locationInView:self];
        UIGraphicsBeginImageContext(self.frame.size);
        
        CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectMake(curPoint.x, curPoint.y, _curSize, _curSize));
        
//        CGPoint currentPoint = [touch locationInView:imageView];
//        UIGraphicsBeginImageContext(self.imageView.frame.size);
//        [imageView.image drawInRect:imageView.bounds];
//        CGContextClearRect (UIGraphicsGetCurrentContext(), CGRectMake(currentPoint.x, currentPoint.y, 30, 30));
//        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_isPalette) {
        NSMutableDictionary *curStrokeDic = [[NSMutableDictionary alloc] init];
        
        [curStrokeDic setValue:_curColor forKey:@"color"];
        
        [curStrokeDic setValue:[NSNumber numberWithFloat:_curSize] forKey:@"size"];
        
        [curStrokeDic setValue:[NSArray arrayWithArray:_strokeNewPoints] forKey:@"points"];
        
        [_strokesArr addObject:curStrokeDic];
        
        if (curStrokeDic.count > 0) {
            _isChange = YES;
        }
        
    }
}

- (void)changeCurWidthWithSize:(float)size {
    _curSize = size;
}

- (void)changeCurColorWithColor:(UIColor *)color {
    _curColor = color;
}

- (void)changeColorAlphaWithValue:(CGFloat)alpha {
    UIColor *reColor = [_curColor colorWithAlphaComponent:alpha];
    
    _curColor = nil;
    
    _curColor = reColor;
}

- (UIImageView *)createItemWithTag:(NSInteger)tag {
    NSLog(@"--------->createItemWithTag:");
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *pName = @"palette_item_";
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    NSDictionary *dic = [self dicOfPicNum];
    
    int nums = [[dic objectForKey:[NSString stringWithFormat:@"%zi", tag] ] intValue];
    
    for (int i = 1; i <= nums; i++) {
        NSString *picName = [NSString stringWithFormat:@"%@%02zi_%02i.png", pName, tag, i];
        
        NSString *picPath = [mainBundle pathForResource:picName ofType:nil];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:picPath];
        
        [images addObject:image];
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    // 添加ImageView的背景
    NSString *picName = [NSString stringWithFormat:@"%@%02zi_%02i.png", pName, tag, 1];
    
    NSString *picPath = [mainBundle pathForResource:picName ofType:nil];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:picPath];
    
    imgView.image = image;
    
    // 添加ImageView的动画
    imgView.animationImages = images;
    
    imgView.animationRepeatCount = 0;
    
    imgView.animationDuration = 0.1 * nums;
    
    [imgView startAnimating];
    
    return imgView;
}

- (void)changeToPalette:(BOOL)judge {
    _isPalette = judge;
}

- (NSDictionary *)dicOfPicNum {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *path = [mainBundle pathForResource:@"itemPicNum" ofType:@"plist"];
    
    NSDictionary *mainDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return mainDictionary;
}

- (BOOL)backAboutChange {
    
    if (_isChange) {
        _isChange  = !_isChange;
        
        return !_isChange;
    }
    
    return _isChange;
}

- (NSMutableDictionary *)saveCurData {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:_strokesArr forKey:@"strokesArr"];
    
    [dic setObject:_curColor forKey:@"curColor"];
    
    [dic setObject:[NSNumber numberWithFloat:_curSize] forKey:@"curSize"];
    
    return dic;
}

- (void)recoverDataWithDic:(NSDictionary *)dic {
    _strokesArr = [dic objectForKey:@"strokesArr"];
    
    _curColor = [dic objectForKey:@"curColor"];
    
    _curSize = [[dic objectForKey:@"curSize"] floatValue];
    
    [self setNeedsDisplay];
}

@end
