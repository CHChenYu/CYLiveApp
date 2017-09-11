//
//  CYPlayerController.m
//  CYLiveApp
//
//  Created by chenyu on 2017/9/3.
//  Copyright © 2017年 chenyu. All rights reserved.
//

#import "CYPlayerController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <UIImageView+WebCache.h>
#import "YZLiveItem.h"
#import "YZCreatorItem.h"
#import "ZLLiveHeartView.h"

@interface CYPlayerController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation CYPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton*back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor redColor]];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    // 设置直播占位图片
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",_live.creator.portrait]];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    // 拉流地址
    NSURL *url = [NSURL URLWithString:_live.stream_addr];
    
    // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
    IJKFFMoviePlayerController *playerVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    // 准备播放
    [playerVc prepareToPlay];
    
    // 强引用，反正被销毁
    _player = playerVc;
    
    playerVc.view.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:playerVc.view];
    [self.view addSubview:back];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(showLiveHeartView) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)showLiveHeartView {
    
    ZLLiveHeartView *heart = [[ZLLiveHeartView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(self.view.frame.size.width - 80, self.view.bounds.size.height - 30 / 2.0 - 10);
    heart.center = fountainSource;
    [heart liveHeartAnimateInView:self.view];
}

   // [self.view insertSubview:playerVc.view atIndex:1];
    

-(void)back:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_timer invalidate];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
}



@end
