//
//  ViewController.m
//  趣味画板
//
//  Created by readboy1 on 15/6/2.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DrawingController.h"

@interface ViewController () <AVAudioPlayerDelegate> {
    
    NSBundle *_mainBundle;
    
    NSDictionary *_mainDictionary;
    
    AVAudioPlayer *_player;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self playAllAnimation];

    [self performSelector:@selector(playVoice) withObject:nil afterDelay:1.0f];
}

#pragma mark - 逐个播放动画
- (BOOL)playAllAnimation {
    
    // 1.获取项目资源根路径
    if (!_mainBundle) {
        
        _mainBundle = [NSBundle mainBundle];
    }
    
    // 2.获取plist文件资源
    if (!_mainDictionary) {
        
        NSString *path = [_mainBundle pathForResource:@"mainAnimations" ofType:@"plist"];
        
        _mainDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    // 3.播放动画
    // 3.1.获取字典所有key
    NSArray *keys = _mainDictionary.allKeys;
    
    // 3.2.根据获得的key播放动画
    for (int i = 0; i < keys.count; i++) {
        
        [self playAnimationWithName:keys[i] andCount:[[_mainDictionary objectForKey:keys[i]] intValue] andTag:i+1];
    }
    
    return true;
}

#pragma mark - 播放单个动画
- (void)playAnimationWithName:(NSString *)name andCount:(int)count andTag:(int)tag{
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= count; i++) {
        
        NSString *picName = [NSString stringWithFormat:@"%@%02i.png", name, i];
        
        NSString *picPath = [_mainBundle pathForResource:picName ofType:nil];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:picPath];
        
        [images addObject:image];
    }
    
    // 获取目标视图
    UIImageView *imageView =(UIImageView *)[self.view viewWithTag:tag];
    
    // 目标视图播放动画
    imageView.animationImages = images;
    
    imageView.animationRepeatCount = 0;
    
    if (tag == 1) {
        
        imageView.animationRepeatCount = 1;
    }
    
    imageView.animationDuration = 0.1 * count;
    
    [imageView startAnimating];
    
}

#pragma mark - 播发独白
- (void)playVoice {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"welcome_start" ofType:@"mp3"]];
    
    NSError *err;
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    NSLog(@"err ---> %@", err);
    
    _player.delegate = self;
    
    [_player prepareToPlay];
    
    [_player play];
    NSLog(@"开始播发...");
}

#pragma mark - AVAudioPlayer代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{    
    [self enterDrawRoom];
}

- (void)enterDrawRoom {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FunDraw" bundle:nil];
    
    DrawingController *drawingController = [storyboard instantiateViewControllerWithIdentifier:@"DrawingController"];
    
    drawingController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    [self presentViewController:drawingController animated:YES completion:^{
        NSLog(@"已经进入画室界面...");
        
        // 释放当前资源
        [self releaseAllContact];
    }];
}

- (IBAction)rbClose:(UIButton *)sender {
    NSLog(@"关闭系统...");
    
    exit(0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"你点击屏幕了...");
    
    [_player stop];
    
    _player = nil;
    
    [self enterDrawRoom];
}

// 释放所有引用
- (void)releaseAllContact {
    _rbAngel = nil;
    
    _rbButterfly = nil;
    
    _rbMushroom = nil;
    
    _rbPigment = nil;
    
    _rbTitle = nil;
}

@end
