//
//  ViewController.m
//  aaa
//
//  Created by jiayazi on 16/11/4.
//  Copyright © 2016年 jiayazi. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JYZRecorder.h"

#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tempRecord.data"]

@interface ViewController ()

//播放器
@property(strong, nonatomic)AVPlayer * player;
@property(strong, nonatomic)AVPlayerItem * palyItem;


@property(strong, nonatomic)JYZRecorder * recorderJIa;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _recorderJIa = [JYZRecorder initRecorder];
    _recorderJIa.recordName = @"kkk.aac";
    
}

//开始录音
- (IBAction)recordBtn:(UIButton *)sender {
    [_recorderJIa startRecorder];
    
}

//结束录音
- (IBAction)recordStop:(UIButton *)sender {
    [_recorderJIa stopRecorder];
    
}

//暂停录音
- (IBAction)pauseRecord:(UIButton *)sender {
    [_recorderJIa pauseRecorder];
    
}

//继续录音
- (IBAction)pauseStart:(UIButton *)sender {
    [_recorderJIa pauseToStartRecorder];
}




//播放录音
- (IBAction)playBtn:(UIButton *)sender {
    
    NSURL * audioUrl  = [NSURL fileURLWithPath:[RecordFile stringByAppendingString:@"kkk.aac"]];
    //    NSURL * audioUrl = [NSURL URLWithString:@"http://voice.haiziyouke.com/guojiliyi.mp3"];
    _palyItem = [[AVPlayerItem alloc]initWithURL:audioUrl];
    _player = [[AVPlayer alloc]initWithPlayerItem:_palyItem];
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    
    [sender.layer addSublayer:playerLayer];
    [_player play];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
