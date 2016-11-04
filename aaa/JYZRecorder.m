//
//  JYZRecorder.m
//  aaa
//
//  Created by jiayazi on 16/11/4.
//  Copyright © 2016年 jiayazi. All rights reserved.
//

#import "JYZRecorder.h"
#import <AVFoundation/AVFoundation.h>

#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tempRecord.data"]

@interface JYZRecorder();

/***  录音对象  */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/***  计时器  */
@property (nonatomic, strong) NSTimer *levelTimer;
/***  计时器对象++1  */
@property (assign, nonatomic)CGFloat timer;
/** 当前暂停的时间 */
@property (assign, nonatomic) NSTimeInterval pauseTime;


/** 最终录音总时间 */
@property (assign, nonatomic) NSInteger recordTotalTime;
@end

@implementation JYZRecorder

/**
 *  快速初始化
 *
 *  @return 录音对象
 */
+(JYZRecorder *)initRecorder{
    
    JYZRecorder * recoder = [[JYZRecorder alloc] init];
    return recoder;
}



/**
 *  开始录音
 *
 *  @param basePath 设置录音基础路径（后面要加上具体录音的名字）
 */
-(void)startRecorder{
    //初始化一些值
    _pauseTime = 0;
    
    //处理权限问题
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    //设置AVAudioSession
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    [audioSession setActive:YES error:nil];
    if(err) {
        NSLog(@"获取权限失败");
        return;
    }
    
    
    //初始化生成录音对象
    err = nil;
    NSURL *recordedFile = [NSURL fileURLWithPath:[RecordFile stringByAppendingString:_recordName]];
    NSDictionary *dic = [self recordingSettings];
    _recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:dic error:&err];
    if(_recorder == nil) {
        NSLog(@"生成录音对象失败");
        return;
    }
    
    
    //准备和开始录音
    [_recorder prepareToRecord];
    //启用录音测量
    _recorder.meteringEnabled = YES;
    //开始录音
    [_recorder record];
    [_recorder recordForDuration:0];
    
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
    NSLog(@"当前时间 == %f",_timer);
    int countDown = 0;
    //在这里要判断是否设置最大录音时间
    if (_recordMaxTime > 0) {
        countDown = _recordMaxTime - _timer;
    }else{
        countDown = 60 - _timer;
    }

    NSLog(@"还可以录制%d",countDown);
    
    if (countDown < 1) {
        NSLog(@"语音最长只能120秒哦");
        [self stopRecorder];
    }
    
}


/**
 *  暂停录音
 */
-(void)pauseRecorder{
    [_recorder pause];
    _pauseTime = _recorder.currentTime;
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    NSLog(@"已经暂停录音");
}

/**
 *  暂停后 继续开始录音
 */
-(void)pauseToStartRecorder{
    [_recorder recordAtTime:_pauseTime];
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(startTime) userInfo: nil repeats: YES];
    NSLog(@"已经暂停 to 开始录音");
}



/**
 *  结束录音
 */
-(void)stopRecorder{
    if (_recorder) {
        [_recorder stop];
    }
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
    _recordTotalTime = _timer;
    _timer = 0;
    NSLog(@"结束录音");
}

/**
 *  获取录音总时间
 */
-(NSInteger)getRecorderTotalTime{
    return _recordTotalTime;
}


/**
 *  获取录音地址
 */
-(NSString *)getRecorderUrlPath{
    return [RecordFile stringByAppendingString:_recordName];
}



/**
 *  删除录音
 */
-(void)deleteRecord{
    [_recorder stop];
    //删除本地录音文件
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    [fileManager removeItemAtPath:[self getRecorderUrlPath] error:nil];
}


/**
 *  重置l录音器
 */
-(void)resetRecorder{
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    _timer = 0;
    _pauseTime = 0;
    _recordTotalTime = 0;
    [self deleteRecord];

}

/**
 *  设置录音一些属性
 */
- (NSDictionary *)recordingSettings
{
    NSMutableDictionary *recordSetting =[NSMutableDictionary dictionaryWithCapacity:10];
    // 音频格式
    recordSetting[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
    // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    recordSetting[AVSampleRateKey] = @(44100);
    // 音频通道数 1 或 2
    recordSetting[AVNumberOfChannelsKey] = @(1);
    // 线性音频的位深度  8、16、24、32
    recordSetting[AVLinearPCMBitDepthKey] = @(16);
    //录音的质量
    recordSetting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
    
    return recordSetting;
}


@end
