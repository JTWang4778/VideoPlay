//
//  JTPLayerView.m
//  MediaPlayer
//
//  Created by 王锦涛 on 2017/6/3.
//  Copyright © 2017年 JTWang. All rights reserved.
//

#import "JTPLayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface JTPLayerView()

@property (nonatomic,strong)AVPlayer *avPlayer;

@property (nonatomic,assign)CGFloat total;

@property (nonatomic,assign)CGPoint startPoint;
@property (nonatomic,assign)CGPoint endPoint;
@property (nonatomic,assign)CGFloat currentBritness;
@property (nonatomic,assign)CGFloat yinliang;

@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view

@property (strong, nonatomic) UISlider* volumeViewSlider;
@end
@implementation JTPLayerView

- (MPVolumeView *)volumeView{
    
    if (_volumeView == nil) {
        _volumeView = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]) {
            // [view.class isSubclassOfClass:[UISlider class]
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                self.volumeViewSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://cdn-qiniu-hls-ssl.gn100.com/hls/1496395048/246_67579_167774822/W1swLDMxMDVdXQ/low.m3u8?qiniu_key=1496779148-0-0-cbe75515fdf6bf2645d9b59e08601723"]];
        self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        playerLayer.videoGravity = AVLayerVideoGravityResize;
        playerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.layer addSublayer:playerLayer];
        [self.avPlayer play];
        
//         添加对缓冲进度和状态的监听
        [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        self.volumeView.frame = CGRectMake(-1000, -1000, 20, 20);
//        [self addSubview:self.volumeView];
        
        UIButton *scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scaleButton setTitle:@"全屏" forState:UIControlStateNormal];
        [scaleButton setTitle:@"缩小" forState:UIControlStateSelected];
        [scaleButton sizeToFit];
        scaleButton.frame = CGRectMake(frame.size.width - scaleButton.frame.size.width - 20, frame.size.height - scaleButton.frame.size.height - 20, scaleButton.frame.size.width, scaleButton.frame.size.height);
        [scaleButton addTarget:self action:@selector(didClickScale:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:scaleButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    playerLayer.frame = self.bounds;
}

- (void)didClickScale: (UIButton *)sender{
    
    if (sender.selected) {
        NSLog(@"缩小");
        [self.delegate small];
    }else{
        
        [self.delegate big];

    }
    sender.selected = !sender.selected;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        //获取缓冲进度
        NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
        // 获取缓冲区域
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //开始的时间
        NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
        //表示已经缓冲的时间
        NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 计算缓冲总时间
        NSTimeInterval result = startSeconds + durationSeconds;
//        NSLog(@"开始:%f,持续:%f,总时间:%f", startSeconds, durationSeconds, result);
//        NSLog(@"视频的加载进度是:%%%f", durationSeconds / self.total * 100);
    }else if ([keyPath isEqualToString:@"status"]){
        //获取播放状态
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"准备播放");
            //获取视频的总播放时长
            [self.avPlayer play];
            self.total = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
            self.currentBritness = [UIScreen mainScreen].brightness;
            self.yinliang = self.volumeViewSlider.value;
        } else{
            NSLog(@"播放失败");
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    NSLog(@"touchesMoved");
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    NSLog(@"touchesEnded");
    UITouch *touch = [touches anyObject];
    self.endPoint = [touch locationInView:self];
    
    if (self.startPoint.x < self.frame.size.width * 0.5 && self.endPoint.x < self.frame.size.width * 0.5) {
        
        if ((self.endPoint.y - self.startPoint.y) > 30) {
            NSLog(@"下滑");
            self.yinliang = self.yinliang - 0.2;
            if (self.yinliang < 0) {
                self.yinliang = 0;
            }
            self.volumeViewSlider.value = self.yinliang;
            [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            NSLog(@"音量%f",self.yinliang);
        }else if ((self.endPoint.y - self.startPoint.y) < -30) {
            NSLog(@"上滑");
            self.yinliang = self.yinliang + 0.2;
            if (self.yinliang > 1.0) {
                self.yinliang = 1.0;
            }
            self.volumeViewSlider.value = self.yinliang;
            [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            NSLog(@"音量%f",self.yinliang);
        }
        // 屏幕左边 上下滑动控制音量
        return;
    }
    if (self.startPoint.x > self.frame.size.width * 0.5 && self.endPoint.x > self.frame.size.width * 0.5) {
        // 屏幕右边边 上下滑动控制亮度
        if ((self.endPoint.y - self.startPoint.y) > 30) {
            ;
            self.currentBritness = self.currentBritness - 0.2;
            if (self.currentBritness < 0) {
                self.currentBritness = 0;
            }
            [[UIScreen mainScreen] setBrightness:self.currentBritness];
            NSLog(@"%f",self.currentBritness);
        }else if ((self.endPoint.y - self.startPoint.y) < -30) {
            self.currentBritness = self.currentBritness + 0.2;
            if (self.currentBritness > 1.0) {
                self.currentBritness = 1.0;
            }
            [[UIScreen mainScreen] setBrightness:self.currentBritness];
            NSLog(@"%f",self.currentBritness);
        }
        return;
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    NSLog(@"touchesCancelled");
    
}
@end
