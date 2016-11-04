//
//  JYZRecorder.h
//  aaa
//
//  Created by jiayazi on 16/11/4.
//  Copyright © 2016年 jiayazi. All rights reserved.
//

/*
 *  功能简介和说明：
 *  提供录音 录音相关设置  暂停录音  删除录音等功能
 *
 *  提示：一定要设置录音的名字
 *
 */

#import <Foundation/Foundation.h>

@interface JYZRecorder : NSObject

/**
 *  录音文件名字(必须要设置)
 */
@property(copy, nonatomic)NSString * recordName;


/**
 *  设置录音最大时长（默认为60秒）
 */
@property(assign, nonatomic)NSInteger recordMaxTime;

/**
 *  快速初始化
 *
 *  @return 录音对象
 */
+(JYZRecorder *)initRecorder;


/**
 *  开始录音
 *
 *  @param basePath 设置录音基础路径（后面要加上具体录音的名字）
 */
-(void)startRecorder;

/**
 *  开始录音计时
 */
- (void)startTime;

/**
 *  暂停录音
 */
-(void)pauseRecorder;

/**
 *  暂停后 继续开始录音
 */
-(void)pauseToStartRecorder;

/**
 *  结束录音
 */
-(void)stopRecorder;


/**
 *  获取录音总时间
 */
-(NSInteger)getRecorderTotalTime;


/**
 *  获取录音地址
 */
-(NSString *)getRecorderUrlPath;


/**
 *  删除录音
 */
-(void)deleteRecord;

/**
 *  重置录音器
 */
-(void)resetRecorder;

@end
