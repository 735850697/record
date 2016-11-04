//
//  JYZPlayer.m
//  aaa
//
//  Created by jiayazi on 16/11/4.
//  Copyright © 2016年 jiayazi. All rights reserved.
//

#import "JYZPlayer.h"

@interface JYZPlayer()

/***  计时器  */
@property (nonatomic, strong) NSTimer *levelTimer;
/***  计时器对象++1  */
@property (assign, nonatomic)CGFloat timer;

@end

@implementation JYZPlayer

/**
 *  快速初始化
 */
+(JYZPlayer *)initPlay{
    JYZPlayer * play = [[JYZPlayer alloc] init];
    return play;
}


/**
 *  播放音频
 *
 *  @param url 音频的url字符串
 */
-(void)playAudioWithUrlStr:(NSString *)url PlayerLayer:(CGRect)layerFrame{
    NSURL * audioUrl  = [NSURL URLWithString:url];
    _palyItem = [[AVPlayerItem alloc]initWithURL:audioUrl];
    _player = [[AVPlayer alloc]initWithPlayerItem:_palyItem];
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame=layerFrame;
    [_player play];
    
    //监听播放状态（AVPlayerStatusReadyToPlay时代表视频已经可以播放了）
    [_palyItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听缓冲状态
    [_palyItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    
    //监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(playerItemDidReachEnd)
     
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
     
                                               object:_palyItem];
    
    //开始计时
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
    _timer = 0;
     self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(startTime) userInfo: nil repeats: YES];
}


/**
 *  开始录音计时
 */
- (void)startTime {
    _timer++;
    
}

/**
 *  暂停播放语音
 */
-(void)pausePalyAudio{
    [_player pause];
}

/**
 *  暂停 to 播放语音
 */
-(void)pauseToPalyAudio{
    CMTime time = CMTimeMake(_timer*10000, 10000);
    [_player seekToTime:time];
}


/**
 *  停止播放语音
 */
-(void)stopPalyAudio{
    [_player pause];
}


//监听播放结束
-(void)playerItemDidReachEnd{
    _audioPlayEnd();
}


/**
 *  重置播放器
 */
- (void)resetAudioPlay{
    [_player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:_player];
    [_palyItem removeObserver:self forKeyPath:@"status"];
    [_palyItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _palyItem = nil;
}



//监听播放状态和缓冲状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {

        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            _playState = PlayerStatePlaying;
            
            //CMTime duration = _palyItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            //[self monitoringPlayback:_palyItem];// 监听播放状态
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            _playState = PlayerStateFailed;
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = _palyItem.duration;
        _totalDurationTime = CMTimeGetSeconds(duration);
    }
}



//计算缓冲时间
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


//时间转换
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}



@end
