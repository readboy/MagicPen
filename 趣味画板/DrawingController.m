//
//  DrawingController.m
//  趣味画板
//
//  Created by readboy1 on 15/6/3.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import "DrawingController.h"
#import "MyCanvas.h"
#import "MyScrollView.h"
#import "WorksController.h"


// 笔刷颜色可选总数
#define kPaletteColorsNum 17
#define kPaletteBGNum 12
#define kPaletteItemNum 21
#define kColorBtnWidth 45.0
#define kUIColorFromRGB(rbgValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DrawingController () <UIAlertViewDelegate> {
    // 记录工具按钮打开/关闭状态
    BOOL _kitShowed;
    // 记录盒子按钮打开/关闭状态
    BOOL _boxShowed;
    // 记录工具选项
    int _kitSelected;
    // 画板
    MyCanvas *_myCanvas;
    // 笔刷大小对应的子视图索引
    int _widthSelViewNum;
    // 记录正在使用的时铅笔(YES)还是橡皮擦(NO)
    BOOL _isPencil;
    // 内容板滚轴
    MyScrollView *_myScroll;
    // 滚轴内图片按钮数量
    int _scrollPicNum;
    // 内容板中笔刷颜色选择索引
    int _paletteColorSelNum;
    // 内容板中画板背景选择索引
    int _boardBGSelNum;
    // 内容板中小动画插件选择索引
    int _itemSelNUm;
    // 小动画管理数组
    NSMutableArray *_itemsArray;
    // 小动画管理数组选项
    int _itemArrSel;
    // 记录笔刷的颜色数组
    NSArray *_paletteColorArr;
    // 判断画板内容是否有所变更
    BOOL *_isChange;
    // 记录所有保存的画名
    NSMutableArray *_savePicName;       //初始化与plist的加载
    // 保存作品的数组（与名称数组一一对应）
//    NSMutableArray *_saveWorksArr;
    // 保存所有作品的字典
    NSMutableDictionary *_saveWorksDic; //初始化与plist的加载
    // 恢复数据对应的索引(>0有效)
    int _recIndex;
    
}

@end

@implementation DrawingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载plist数据
    [self loadWorksData];
    
    // 初始化画板
    [self initMyCanvas];
}

- (void)initMyCanvas {
    NSLog(@"initMyCanvas");
    
    _myCanvas = [[MyCanvas alloc] initWithFrame:_paletteLocation.bounds];
    
    [_paletteLocation addSubview:_myCanvas];
    
    _paletteLocation.userInteractionEnabled = YES;
    
    // 恢复关于笔刷大小的设置
    [self setWidthSizeAndView];
    
    // 设置笔刷模式
    [_myCanvas changeToPalette:YES];
    
    // 恢复内容选择板
    [self setContentSelectBoardWithTag:1];
    
    // 默认数据
    [self defaultParameter];
    
    [self recoverSelData];
}

- (void)setWidthSizeAndView {
    NSLog(@"setWidthSizeAndView");
    
    if (_widthSelViewNum < 0) {
        _widthSelViewNum = 0;
    }
    
    // 修改笔刷大小
    [_myCanvas changeCurWidthWithSize:(1.0 + (_widthSelViewNum+1) * (_widthSelViewNum+1))];
    // 改变笔刷对应的视图边框    
    NSString *picName = [NSString stringWithFormat:@"palette_pensize_sel.png"];
    
    NSString *picPath = [[NSBundle mainBundle] pathForResource:picName ofType:nil];
    
    UIImage *imageSel = [[UIImage alloc] initWithContentsOfFile:picPath];
    
    UIButton *preWidthBtn = (UIButton *)(_widthViews.subviews[_widthSelViewNum]);
    
    [preWidthBtn setBackgroundImage:imageSel forState:UIControlStateNormal];
}

- (void)setContentSelectBoardWithTag:(NSInteger)tag {
    NSLog(@"setContentSelectBoardWithTag:");
    
    if (!_myScroll) {
        _myScroll = [[MyScrollView alloc] initWithFrame:self.contentSelBoard.bounds];
        
        [self.contentSelBoard addSubview:_myScroll];
        
    } else {
        for (UIView *myView in _myScroll.subviews) {
            [myView removeFromSuperview];
        }
    }
    
    switch (tag) {
        case 1:
            [self contentOfPencilColor];
            break;
            
        case 3:
            [self contentOfBoardBG];
            break;
            
        case 4:
            [self contentOfItem];
            break;
    }    
    
}

- (void)addBtnToScrollWithPicName:(NSString *)pName andPicNum:(NSInteger)picNum andSelNum:(NSInteger)selNum andSelPicName:(NSString *)selPicName andAction:(SEL)action{
    NSLog(@"addBtnToScrollWithPicName:");
    
    // 根据约定数量加载颜色板
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    CGRect bounds  = _contentSelBoard.bounds;
    
    float btnY = bounds.size.width+5;
    
    _myScroll.contentSize = CGSizeMake(bounds.size.width, btnY * picNum);
    
    _myScroll.showsVerticalScrollIndicator = NO;
    
    _scrollPicNum = (int)picNum;
    
    for (int i = 0; i < picNum; i++) {
        // 获取颜色图片img
        NSString *picName = [NSString stringWithFormat:@"%@%02i.png", pName, i+1];
        
        NSString *picPath = [mainBundle pathForResource:picName ofType:nil];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:picPath];
        
        // 创建子视图btn
        CGRect frame = CGRectMake(0, btnY * i, bounds.size.width, bounds.size.width);
        
        UIButton *btnSel = [[UIButton alloc] initWithFrame:frame];
        
        btnSel.enabled = YES;
        
        btnSel.tag = i + 1;

        [btnSel addTarget:self action:action forControlEvents:1];
        
        // 设置btn内容图片img
        [btnSel setBackgroundImage:image forState:UIControlStateNormal];
        
        // 设置被选的背景
        if (i == selNum) {
            [btnSel setImage:[UIImage imageNamed:selPicName] forState:UIControlStateNormal];
        }
        
        // 把btn添加到myScroll中
        [_myScroll addSubview:btnSel];
    }
}

#pragma mark - 在内容板中添加笔刷颜色选中按钮
- (void)contentOfPencilColor {
    _paletteColorArr = @[@"0xff010100",
                         @"0xffff7fa6",
                         @"0xffff0000",
                         @"0xffe400ff",
                         @"0xff894a00",
                         @"0xffff6f17",
                         @"0xffff99ff",
                         @"0xffffcc00",
                         @"0xffffff66",
                         @"0xff43c7fe",
                         @"0xffcc8836",
                         @"0xffe0e0e0",
                         @"0xff05cb05",
                         @"0xfff5f800",
                         @"0xff00ffb9",
                         @"0xff66ff66",
                         @"0xff0066ff"];
    
    [self addBtnToScrollWithPicName:@"palette_color" andPicNum:kPaletteColorsNum andSelNum:_paletteColorSelNum andSelPicName:@"palette_color_sel.png" andAction:@selector(btnColorSelected:)];
}
// 按钮调用的点击事件
- (void)btnColorSelected:(UIButton *)btn {
    NSLog(@"btnColorSelected: btn.tag ---> %zi", btn.tag);
    
    // 取消被选择按钮的背景
    UIButton *preBtn = _myScroll.subviews[_paletteColorSelNum];
    
    [preBtn setImage:nil forState:UIControlStateNormal];
    
    // 给新按钮添加选中背景
    [btn setImage:[UIImage imageNamed:@"palette_color_sel.png"] forState:UIControlStateNormal];
    
    _paletteColorSelNum = (int)(btn.tag - 1);
    
    // 更新笔刷颜色
    [_myCanvas changeCurColorWithColor:[self colorForTag:btn.tag]];
}

- (UIColor *)colorForTag:(NSInteger)tag {
    unsigned long colorName = strtoul([_paletteColorArr[tag-1] UTF8String], 0, 0);
    UIColor *color = [self colorWithHex:colorName];
    
    return color;
}

- (UIColor *)colorWithHex:(long)hexColor {
    float red = ((float)((hexColor & 0xFF0000) >> 16)) / 255.0;
    
    float green = ((float)((hexColor & 0xFF00) >> 8)) / 255.0;
    
    float blue = ((float)(hexColor & 0xFF)) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

#pragma mark - 在内容板中添加画板背景选中按钮
- (void)contentOfBoardBG {
    [self addBtnToScrollWithPicName:@"palette_background_" andPicNum:kPaletteBGNum andSelNum:_boardBGSelNum andSelPicName:@"palette_background_sel.png" andAction:@selector(btnBGSelected:)];
}
// 按钮调用的点击事件
- (void)btnBGSelected:(UIButton *)btn {
    
    UIButton *preBtn = _myScroll.subviews[_boardBGSelNum];
    
    [preBtn setImage:nil forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"palette_background_sel.png"] forState:UIControlStateNormal];
    
    _boardBGSelNum = (int)(btn.tag - 1);
    
    // 画板更换图片
    _paletteLocation.image = [self bgImageForTag:btn.tag];
    NSLog(@"btn.tag ---> %zi", btn.tag);
    
    _isChange = YES;
}
#pragma mark - 返回画板背景图片
- (UIImage *)bgImageForTag:(NSInteger)tag {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *name = @"palette_background_";
    
    NSString *picName = [NSString stringWithFormat:@"%@%02zi.png", name, tag];
    
    NSString *picPath = [mainBundle pathForResource:picName ofType:nil];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:picPath];
    
    return image;
}

#pragma mark - 在内容板中添加动画选中按钮
- (void)contentOfItem {
    
    [self addBtnToScrollWithPicName:@"palette_item_thumb_" andPicNum:kPaletteItemNum andSelNum:_itemSelNUm andSelPicName:@"palette_item_thumb_sel.png" andAction:@selector(btnItemSelected:)];
}

- (void)btnItemSelected:(UIButton *)btn {
    
    UIButton *preBtn = _myScroll.subviews[_itemSelNUm];
    
    [preBtn setImage:nil forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"palette_item_thumb_sel.png"] forState:UIControlStateNormal];
    
    _itemSelNUm = (int)(btn.tag - 1);
    
    // 随机地址添加一个动画
    UIImageView *itemImg = [_myCanvas createItemWithTag:btn.tag];
    
    itemImg.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panGestureRecohnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    [itemImg addGestureRecognizer:panGestureRecohnizer];
    
    [_paletteLocation addSubview:itemImg];
    
    // 把动画添加到管理数组中
    if (!_itemsArray) {
        _itemsArray = [[NSMutableArray alloc] init];
    }
    
    [_itemsArray addObject:itemImg];
    
    // 给UIImageView添加点击事件
    itemImg.tag = _itemsArray.count;
    [itemImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    
    _isChange = YES;
    
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)clickCategory:(UITapGestureRecognizer *)tapgest {
    
    UIImageView *viewClicked = (UIImageView *)[tapgest view];
    
    _itemArrSel = (int)viewClicked.tag - 1;
    NSLog(@"ias --->%i", _itemArrSel);
    viewClicked.image = [UIImage imageNamed:@"palette_item_thumb_sel.png"];
    NSLog(@"viewClicked.image ---> %@", viewClicked.image);
    
    NSLog(@"click view tag ---> %zi", viewClicked.tag);
}

// 获取目标视图某范围内的屏幕截图
- (UIImage *)imageFromView:(UIView *)view andViewBounds:(CGRect)bounds {
    
    UIGraphicsBeginImageContext(view.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


// 保存当前画板内容
- (void)saveCurContent {
    
    if (!_savePicName) {
        _savePicName = [[NSMutableArray alloc] init];
    }
    
    UIImage *img = [self imageFromView:_paletteLocation andViewBounds:_paletteLocation.bounds];
    
    // 把图片保存到沙盒默认路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *fileName = [NSString stringWithFormat:@"screenpicture%@.png", [self getCurTime]];
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    BOOL result = [UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
    
    if (result) {
        NSLog(@"保存成功, filePath ---> %@", filePath);
        
        [_savePicName addObject:fileName];
        
        [self saveCurData];
    } else {
        NSLog(@"保存失败, filePath ---> %@", filePath);
    }
}

- (NSString *)getCurTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    return str;
}

// 对话框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case 1:
            
            if (0 == buttonIndex) {
                [self saveCurContent];
            }
            
            // 进入第三个界面
            [self enterWorks];
            
            break;
            
        case 2:
            
            if (0 == buttonIndex) {
                [self saveCurContent];
            }
            
            [self createOneCanvas];
            
            break;
    }
    
}

// 新画板的默认参数
- (void)defaultParameter {
    
    // 记录工具按钮打开/关闭状态
    _kitShowed = NO;
    // 记录盒子按钮打开/关闭状态
    _boxShowed = NO;
    // 记录工具选项
    _kitSelected = 0;
    // 笔刷大小对应的子视图索引
    _widthSelViewNum = 0;
    // 记录正在使用的时铅笔(YES)还是橡皮擦(NO)
    _isPencil = YES;
    // 滚轴内图片按钮数量
    _scrollPicNum = 0;
    // 内容板中笔刷颜色选择索引
    _paletteColorSelNum = 0;
    // 内容板中画板背景选择索引
    _boardBGSelNum = 0;
    // 内容板中小动画插件选择索引
    _itemSelNUm = 0;
    // 小动画管理数组
    _itemsArray = nil;
    // 小动画管理数组选项
    _itemArrSel = 0;
    // 记录笔刷的颜色数组
    _paletteColorArr = 0;
    // 记录所有保存的画名
//    _savePicName = nil;
    // 判断画板内容是否有所变更
    _isChange = NO;
    
    _paletteLocation.image = [self bgImageForTag:1];
}

// 打包保存当前数据
- (void)saveCurData {
    NSLog(@"saveCurData");
    
    // 把数据保存到字典中去
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithInt:_widthSelViewNum] forKey:@"widthSelViewNum"];
    
    [dic setObject:[NSNumber numberWithInt:_paletteColorSelNum] forKey:@"paletteColorSelNum"];
    
    [dic setObject:[NSNumber numberWithInt:_boardBGSelNum] forKey:@"boardBGSelNum"];
    
    if (!_itemsArray) {
        _itemsArray = [[NSMutableArray alloc] init];
    }
    
    [dic setObject:_itemsArray forKey:@"itemsArray"];
    
    [dic setObject:[_myCanvas saveCurData] forKey:@"myCanvas"];
    
    if (!_saveWorksDic) {
        _saveWorksDic = [[NSMutableDictionary alloc] init];
    }
    
    // 把字典保存到总字典中
    [_saveWorksDic setObject:dic forKey:[_savePicName lastObject]];
    // 把作品名数组保存进同一个数组
    [_saveWorksDic setObject:_savePicName forKey:@"savePicName"];
    
    // 把字典保存到plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:@"MyCanvas.plist"];
    NSLog(@"filename ---> %@\n", fileName);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createFileAtPath:fileName contents:nil attributes:nil];
    
    [_saveWorksDic writeToFile:fileName atomically:YES];
    
}

// 加载原有数据
- (void)loadWorksData {
    NSLog(@"loadWorksData");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"MyCanvas.plist"];
    NSLog(@"filePath ---> %@", filePath);
    
    //判断目标文件是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSLog(@"加载时plist文件已经存在...");
    } else {
        NSLog(@"加载时plist文件不存在...");
    }

#warning 无法加载plist文件数据
    _saveWorksDic = (NSMutableDictionary *)[NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"_saveWorksDic ---> %@", _saveWorksDic);
    NSLog(@"dic --- >%@", [NSDictionary dictionaryWithContentsOfFile:filePath]);
    
    if (_saveWorksDic) {
        NSLog(@"成功加载数据...");
        _savePicName = [_saveWorksDic objectForKey:@"savePicName"];
        

        [_saveWorksDic removeObjectForKey:@"savePicName"];

    } else {
        
    }
    NSLog(@"数据加载结束...");
}

// 恢复某画数据
- (void)recoverSelData {
    NSLog(@"recoverSelData");
    
    if (_recIndex > 0) {
        NSLog(@"开始恢复...");
        
        NSString *worksName = _savePicName[_recIndex - 1];
        
        NSDictionary *dic = [_saveWorksDic objectForKey:worksName];
        
        _widthSelViewNum = [[dic objectForKey:@"widthSelViewNum"] intValue];
        
        _paletteColorSelNum = [[dic objectForKey:@"paletteColorSelNum"] intValue];
        
        _boardBGSelNum = [[dic objectForKey:@"boardBGSelNum"] intValue];
        
        _itemsArray = [dic objectForKey:@"itemsArray"];
        
        for (UIView *view in _itemsArray) {
            [_paletteLocation addSubview:view];
        }
        
        [_myCanvas recoverDataWithDic:[dic objectForKey:@"myCanvas"]];
        
        _recIndex = 0;
    }
    
    NSLog(@"_savePicName ---> %@",_savePicName);
    NSLog(@"界面的跳转会使属性被从新创建...");
}

// 设置要恢复的画索引
- (void)setRecoverSelIndex:(NSInteger)tag {
    _recIndex = (int)tag;
    
    [self initMyCanvas];
}

// 进入第三界面
- (void)enterWorks {
    // 使用模态视图打开第三界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FunDraw" bundle:nil];
    
    WorksController *worksController = [storyboard instantiateViewControllerWithIdentifier:@"WorksController"];
    
    [worksController setDataWithNameArr:_savePicName andWorksData:_saveWorksDic];
    
    worksController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:worksController animated:YES completion:^{
        NSLog(@"打开第三界面");
        
//        [self createOneCanvas];
    }];
}

// 创建一个新画板
- (void)createOneCanvas {
    
    for (UIView *view in [_paletteLocation subviews]) {
        [view removeFromSuperview];
    }
    
    [self initMyCanvas];
}

- (void)updateWorksName:(NSMutableArray *)worksName andWorksData:(NSMutableDictionary *)worksData {
    _savePicName = worksName;

    _saveWorksDic = worksData;
}

#pragma mark - 各视图响应事件
- (IBAction)closeDrawing:(UIButton *)sender {
    
    exit(0);
}

- (IBAction)pageUp:(UIButton *)sender {
    NSLog(@"pageUP");
    
    CGRect showRec = CGRectMake(0, 0, _myScroll.bounds.size.width, _myScroll.bounds.size.height);
    [_myScroll scrollRectToVisible:showRec animated:YES];
}

- (IBAction)pageDown:(UIButton *)sender {
    NSLog(@"pageDown");
    CGRect bounds = _myScroll.bounds;
    
    CGRect showRec = CGRectMake(0, (bounds.size.width + 5)*(_scrollPicNum-3), bounds.size.width, bounds.size.height);
    [_myScroll scrollRectToVisible:showRec animated:YES];
}

- (IBAction)showBox:(UIButton *)sender {
    NSLog(@"showBox:");
}

- (IBAction)showKit:(UIButton *)sender {
    NSLog(@"showKit:");
}

- (IBAction)newWork:(UIButton *)sender {
    NSLog(@"newWork:");
    
    if (_isChange || [_myCanvas backAboutChange]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存当前内容" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        
        [alert show];
        
        alert.tag = 2;
        
        _isChange = NO;
        
    } else {
        [self createOneCanvas];
    }
}

- (IBAction)deleteSomething:(UIButton *)sender {
    NSLog(@"deleteSomething:");
    
    if (_itemArrSel >= 0) {
        UIView *delItem = _itemsArray[_itemArrSel];
    
        [_itemsArray removeObject:delItem];
    
        [delItem removeFromSuperview];
        
        _itemArrSel = -1;
    }
    
}

- (IBAction)works:(UIButton *)sender {
    NSLog(@"works:");
    
    // 当检测到图片内容发送更改时，咨询是否保存当前内容
    if (_isChange || [_myCanvas backAboutChange]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存当前内容" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        
        [alert show];
        
        alert.tag = 1;
        
        _isChange = NO;
    } else {
        [self enterWorks];
    }
}

- (IBAction)itemSel:(UIButton *)sender {
    NSLog(@"itemSel:");
    [_showKit setImage:[UIImage imageNamed:@"btn_item.png"] forState:UIControlStateNormal];
    
    [self setContentSelectBoardWithTag:sender.tag];
}

- (IBAction)backgroundSel:(UIButton *)sender {
    NSLog(@"backgroundSel:");
    [_showKit setImage:[UIImage imageNamed:@"btn_background.png"] forState:UIControlStateNormal];
    
    [self setContentSelectBoardWithTag:sender.tag];
}

- (IBAction)eraser:(UIButton *)sender {
    NSLog(@"eraser...");
    
    [_myCanvas changeToPalette:NO];
    
    [_showKit setImage:[UIImage imageNamed:@"btn_eraser.png"] forState:UIControlStateNormal];
    
//    [_myCanvas changeCurColorWithColor:[UIColor clearColor]];
    
}

- (IBAction)pencil:(UIButton *)sender {
    NSLog(@"pencil:");
    
    [_myCanvas changeToPalette:YES];
    
    // 修改showKit图标
    [_showKit setImage:[UIImage imageNamed:@"btn_pencil.png"] forState:UIControlStateNormal];
    // 修改scrollView中的内容
    [self setContentSelectBoardWithTag:sender.tag];
    
}

- (IBAction)changeWidth:(UIButton *)sender {
    NSLog(@"sender.tag--->%zi",sender.tag);

    UIButton *preWidthBtn = (UIButton *)(_widthViews.subviews[_widthSelViewNum]);
    [preWidthBtn setBackgroundImage:nil forState:UIControlStateNormal];
     
    _widthSelViewNum = (int)(sender.tag - 1);
    
    // 修改笔刷大小及添加对应视图的边框
    [self setWidthSizeAndView];
}


@end
