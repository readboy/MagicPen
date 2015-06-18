//
//  WorksController.m
//  趣味画板
//
//  Created by readboy1 on 15/6/11.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import "WorksController.h"
#import "MyScrollView.h"
#import "MyWorks.h"
#import "DrawingController.h"

@interface WorksController () {
    // 作品集名称数组
    NSMutableArray *_worksNameArr;
    // 作品集Myworks图片数组
    NSMutableArray *_myWorksArr;
    // 作品数据所在字典
    NSMutableDictionary *_worksDic;
    // 作品集滚轴
    MyScrollView *_scrollView;
    // 判断回收状态
    BOOL _recycle;
    
}

@end

@implementation WorksController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadAllWorks];
}
// 加载所有作品
- (void)loadAllWorks {
    NSLog(@"loadAllWorks");
    
    if (_worksNameArr.count > 0) {
        // 初始化scrollview
        _scrollView = [[MyScrollView alloc] initWithFrame:self.worksPlace.bounds];
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.worksPlace addSubview:_scrollView];
        
        for (int i = 0; i < _worksNameArr.count; i++) {
            
            UIImage  *img = [self loadWorksFromLocationWithName:_worksNameArr[i]];
            
            if (img) {  //当成功加载图片时
                
                MyWorks *works = [self loadMyWorksViewWidtIndex:i];
            
                // 添加点击事件
                [works.worksSel addTarget:self action:@selector(btnClickOfSel:) forControlEvents:1];
                [works.worksDel addTarget:self action:@selector(btnClickOfDel:) forControlEvents:1];
            
                works.worksContent.image = img;
            
                if (!_myWorksArr) {
                    _myWorksArr = [[NSMutableArray alloc] init];
                }
            
                [_myWorksArr addObject:works];
            }
            
        }
    }
    
    [self showAllWorks];
}
// 显示所有的作品
- (void)showAllWorks {
    
    for (UIView *view in _scrollView.subviews) {
        
        [view removeFromSuperview];
    }
    
    if (_myWorksArr.count > 0) {
        self.numTips.image = nil;
        
        _scrollView.contentSize = CGSizeMake((_worksPlace.bounds.size.height + 5)* _myWorksArr.count, _worksPlace.bounds.size.height);
        
        for (int i = 0; i < _myWorksArr.count; i++) {
            
            MyWorks *works = _myWorksArr[i];
            NSLog(@"works ---> %@", works);
            // 使用tag标记数组索引+1
            works.worksSel.tag = i+1;
            works.worksDel.tag = i+1;
            
            
            // 更新位置
            [self changeViewFrame:works andIndex:i];
            
            [_scrollView addSubview:works];
        }
    } else {
        // 显示空works提示
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        NSString *picName = [NSString stringWithFormat:@"work_empty_tip.png"];
        
        NSString *picPath = [mainBundle pathForResource:picName ofType:nil];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:picPath];
        
        self.numTips.image = image;
    }
}
// 给作品集数组赋值
- (void)changeWorksNameArr:(NSArray *)worksArr {
    _worksNameArr = (NSMutableArray *)worksArr;
}

- (void)setDataWithNameArr:(NSMutableArray *)worksName andWorksData:(NSMutableDictionary *)worksDataDic {
    
    _worksNameArr = worksName;
    
    _worksDic = worksDataDic;
}

// 根据图片名从本地加载图片
- (UIImage *)loadWorksFromLocationWithName:(NSString *)picName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"paths ---> %@", paths);
    NSString *picPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:picName];
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:picPath];
    
    if (!blHave) {
        NSLog(@"图片不存在...");
        
        return nil;
    } else {
        
        NSData *data = [NSData dataWithContentsOfFile:picPath];
        
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        return img;
    }
}
// 创建自定义视图MyWorks
- (MyWorks *)loadMyWorksViewWidtIndex:(NSInteger)index {
    
    CGFloat vsize = self.worksPlace.bounds.size.height;
    
    CGRect frame = CGRectMake((vsize + 5) * index, 0, vsize, vsize);

    return [MyWorks myWorksWithFrame:frame];
}

- (void)changeViewFrame:(MyWorks *)myWorks andIndex:(NSInteger)index {
    
    CGFloat vsize = self.worksPlace.bounds.size.height;
    
    CGRect frame = CGRectMake((vsize + 5) * index, 0, vsize, vsize);
    
    myWorks.frame = frame;
}

// 回收按钮点击事件
- (void)btnClickOfDel:(UIButton *)btn {
    NSLog(@"btnClickOfDel: ---> index = %zi", btn.tag-1);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // 文件全路径
    NSLog(@"paths --- > %@", [paths objectAtIndex:0]);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", _worksNameArr[btn.tag-1]]];
    NSLog(@"delworkName ---> %@", _worksNameArr[btn.tag-1]);
    
    // 判断文件是否存在
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (!blHave) {
        NSLog(@"目标文件不存在...");
    } else {
        NSError *err = nil;
        
        BOOL blDelete = [fileManager removeItemAtPath:filePath error:&err];
        
        if (blDelete) {
            NSLog(@"删除成功...");
            
            NSLog(@"_worksDic1 ---> %@", _worksDic);
            NSString *key = _worksNameArr[btn.tag - 1];
            [_worksDic removeObjectForKey:key];
            NSLog(@"_worksDic2 ---> %@", _worksDic);
            
            [_worksNameArr removeObjectAtIndex:btn.tag-1];
            
            [_myWorksArr removeObjectAtIndex:btn.tag-1];
            
            [self showAllWorks];
            
        } else {
            NSLog(@"删除失败: %@", err);
        }
    }
}

// 删除集合某一项
- (void)delOneWorksWithTag:(NSInteger)tag {
    
}

// 选择按钮点击事件
- (void)btnClickOfSel:(UIButton *)btn {
    
    NSLog(@"btnClickOfSel: ---> tag = %zi", btn.tag);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DrawingController *drawingController = [storyboard instantiateViewControllerWithIdentifier:@"DrawingController"];
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回第二界面");
        
        [drawingController setRecoverSelIndex:btn.tag];
    }];
}

// ----------------------------
- (IBAction)btnClose:(UIButton *)sender {
    // 返回画室界面，同时更新画室中作品名称数组，以及选中索引
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FunDraw" bundle:nil];
    
    DrawingController *drawingController = [storyboard instantiateViewControllerWithIdentifier:@"DrawingController"];
    
    [drawingController updateWorksName:_worksNameArr andWorksData:_worksDic];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回第二界面");
    }];
}

- (IBAction)btnRecycle:(UIButton *)sender {
    NSLog(@"btnRecycle:");
    
    _recycle = !_recycle;
    
    for (MyWorks *works in _myWorksArr) {
        [works judgeWorksDelBtn:_recycle];
    }
    
    [self showAllWorks];
}

- (IBAction)btnLeft:(UIButton *)sender {
    CGRect showRec = CGRectMake(0, 0, _scrollView.bounds.size.width,_scrollView.bounds.size.height);
    
    [_scrollView scrollRectToVisible:showRec animated:YES];
}

- (IBAction)btnRight:(UIButton *)sender {
    CGRect bounds = _scrollView.bounds;
    
    CGRect showRec = CGRectMake((bounds.size.height + 5)*(_myWorksArr.count-2), 0, bounds.size.width, bounds.size.height);
    [_scrollView scrollRectToVisible:showRec animated:YES];
}



// ------------------------------- 自定义测试数据
- (void)aboutData {
    
    NSArray *arr = @[@"screenpicture0.png", @"screenpicture1.png", @"screenpicture2.png", @"screenpicture3.png", @"screenpicture4.png", @"screenpicture5.png", @"screenpicture6.png", @"screenpicture7.png", @"screenpicture8.png", @"screenpicture9.png", @"screenpicture10.png"];
    
    _worksNameArr = [[NSMutableArray alloc] initWithArray:arr];
}
@end
