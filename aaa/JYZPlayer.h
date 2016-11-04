//
//  JYZPlayer.h
//  aaa
//
//  Created by jiayazi on 16/11/4.
//  Copyright © 2016年 jiayazi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//播放器的几种状态
typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStateFailed,     // 播放失败
    PlayerStateBuffering,  // 缓冲中
    PlayerStatePlaying,    // 播放中
    PlayerStateStopped,    // 停止播放
    PlayerStatePause       // 暂停播放
};


@interface JYZPlayer : NSObject

//播放器
@property(strong, nonatomic)AVPlayer * player;
@property(strong, nonatomic)AVPlayerItem * palyItem;

/** 播发器的几种状态 */
@property (nonatomic, assign) PlayerState       playState;

/**
 *  监听音频播放结束
 */
@property(copy, nonatomic)void(^audioPlayEnd)(void);


/**
 *  快速初始化
 */
+(JYZPlayer *)initPlay;

/**
 *  播放音频
 *
 *  @param url 音频的url字符串
 */
-(void)playAudioWithUrlStr:(NSString *)url PlayerLayer:(CGRect)layerFrame;

/**
 *  停止播放语音
 */
-(void)stopPalyAudio;

/**
 *  暂停播放语音
 */
-(void)pausePalyAudio;

/**
 *  暂停 to 播放语音
 */
-(void)pauseToPalyAudio;


/**
 *  重置播放器
 */
-(void)resetAudioPlay;


/**
 *  总时间
 */
@property(strong, nonatomic)NSString * totalTime;

/**
 *  获取缓冲时间
 */
@property(assign, nonatomic)CGFloat totalDurationTime;

@end
