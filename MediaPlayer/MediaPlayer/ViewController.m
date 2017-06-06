//
//  ViewController.m
//  MediaPlayer
//
//  Created by 王锦涛 on 2017/6/3.
//  Copyright © 2017年 JTWang. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "JTPLayerView.h"

@interface ViewController ()

@property (nonatomic,strong)MPMoviePlayerController *player;

@property (nonatomic,strong)MPMoviePlayerViewController *viewPlayer;

@property (nonatomic,strong)JTPLayerView   *playerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testPlayer];
    
    
}
- (IBAction)didClick:(id)sender {
    [self testViewPlayer];
}

- (IBAction)didClickAVPlayer:(id)sender {
        
    JTPLayerView *playerView = [[JTPLayerView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width * 9.0 / 16.0)];
    [self.view addSubview:playerView];
    
}

- (void)testViewPlayer{
    
    MPMoviePlayerViewController *viewPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://cdn-qiniu-hls-ssl.gn100.com/hls/1475985752/672212_27617_167774822/W1swLDM5MF1d/hd.m3u8?qiniu_key=1496474791-0-0-d4ef95681baff461bdc3a99d972b2335"]];
    /*
     MPMoviePlayerViewController  是一个控制器 是对MPMoviePlayerController 的封装，其中有一个MPMoviePlayerController 的属性 并且让view添加到自身大小  并且提供了模态展示和移除控制器的方法
     
     */
    [viewPlayer.moviePlayer play];
    
//    [self presentMoviePlayerViewControllerAnimated:viewPlayer];
    //  两种模态方式还是有区别的    用提供的方法模态的时候 播放控制器由上往下的动画效果  而正常的模态控制器是由下往上的
    [self presentViewController:viewPlayer animated:YES completion:nil];
}

- (void)testPlayer{
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://cdn-qiniu-hls-ssl.gn100.com/hls/1475985752/672212_27617_167774822/W1swLDM5MF1d/hd.m3u8?qiniu_key=1496474791-0-0-d4ef95681baff461bdc3a99d972b2335"]];
    
    /*
     MPMovieControlStyleNone,       // No controls
     MPMovieControlStyleEmbedded,   // Controls for an embedded view  默认样式
     MPMovieControlStyleFullscreen  // 全屏模式
     */
    self.player.controlStyle = MPMovieControlStyleEmbedded;
    
    
    /*  是否重播
     MPMovieRepeatModeNone,  默认不重播
     MPMovieRepeatModeOne
     */
    self.player.repeatMode = MPMovieRepeatModeOne;
    
    
    /*
     MPMovieScalingModeNone,       // No scaling
     MPMovieScalingModeAspectFit,  // 默认
     MPMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
     MPMovieScalingModeFill
     */
    self.player.scalingMode = MPMovieScalingModeAspectFit;
    self.player.view.frame = CGRectMake(0, 0, 300, 300);
    [self.view addSubview:self.player.view];
    
    [self.player prepareToPlay];
    [self.player play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
