/*
  The Name Of The Project：test_AudioRecorder
  The File Name：ZYVoiceView.mh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/29.
  Copyright ：  Copyright © 2016年 . All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import "ZYVoiceView.h"

#import "XHMessageInputView.h"
#import "XHVoiceRecordHelper.h"
#import "XHAudioPlayerHelper.h"
#import "XHVoiceCommonHelper.h"
#import "WKFRadarView.h"                      // usage of record animation ---> step1


// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;


@interface ZYVoiceView ()<XHMessageInputViewDelegate>

//@property (nonatomic, strong) XHMessageInputView * inputView;
@property (nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

@property (nonatomic, strong) WKFRadarView * radarView; // animation ---> step1


/**
 *  用于显示发送消息类型控制的工具条，在底部
 */
@property (nonatomic, weak, readonly) XHMessageInputView *messageInputView;

/**
 *  判断是不是超出了录音最大时长
 */
@property (nonatomic) BOOL isMaxTimeStop;


@end

@implementation ZYVoiceView

-(void)dealloc{
    NSLog(@"--> %s",__func__);
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self createUIWithFrame:frame];
    }
    return self;
}
- (void)createUIWithFrame:(CGRect)frame {
    
    XHMessageInputView *inputView = [[XHMessageInputView alloc] initWithFrame:self.bounds];
    inputView.allowsSendFace = YES;
    inputView.allowsSendVoice = YES;    // 语音
    inputView.allowsSendMultiMedia = YES;
    inputView.delegate = self;
    [self addSubview:inputView];

    
}

#pragma mark - XHMessageInputView Delegate

- (void)didChangeSendVoiceAction:(BOOL)changed {

}

- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion {
    NSLog(@"prepareRecordingWithCompletion");
    [self prepareRecordWithCompletion:completion];
}

- (void)didStartRecordingVoiceAction {
    NSLog(@"didStartRecordingVoice");
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    NSLog(@"didCancelRecordingVoice");
    [self cancelRecord];
}

- (void)didFinishRecoingVoiceAction {
    NSLog(@"didFinishRecoingVoice");
    if (self.isMaxTimeStop == NO) {
        [self finishRecorded];
    } else {
        self.isMaxTimeStop = NO;
    }
}

- (void)didDragOutsideAction {
    NSLog(@"didDragOutsideAction");
    [self resumeRecord];
}

- (void)didDragInsideAction {
    NSLog(@"didDragInsideAction");
    [self pauseRecord];
}


#pragma mark - Voice Recording Helper Method

- (void)prepareRecordWithCompletion:(XHPrepareRecorderCompletion)completion {
    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:completion];
}

- (void)startRecord {
    self.radarView.hidden = NO; //touch down
    //解决出现的bug -- 无动画show图
    [self.radarView goonAnimating]; // 录音动画 动ing
    
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
    }];
}

- (void)finishRecorded {
    WEAKSELF
    self.radarView.hidden = YES;
    
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        [weakSelf didSendMessageWithVoice:weakSelf.voiceRecordHelper.recordPath voiceDuration:weakSelf.voiceRecordHelper.recordDuration];
    }];
}

- (void)pauseRecord {

    [self.radarView goonAnimating]; //drag in

}

- (void)resumeRecord {

    [self.radarView stopAnimating]; //drag out

}

- (void)cancelRecord {

    self.radarView.hidden = YES;    //隐藏弹框
    
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        NSLog(@"cancel end");
    }];
}


- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.m4a", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

- (void)didSendMessageWithVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration {
    NSLog(@"send voicePath : %@ --voiceDuration : %@", voicePath,voiceDuration);

    // + 回调给外界
    self.zyVoiceCBBlock(voicePath,voiceDuration);
}

# pragma mark - 懒加载
- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        _isMaxTimeStop = NO;
        
        WEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            NSLog(@"已经达到最大限制时间了，进入下一步的提示");
            
            // Unselect and unhilight the hold down button, and set isMaxTimeStop to YES.
            UIButton *holdDown = weakSelf.messageInputView.holdDownButton;
            holdDown.selected = NO;
            holdDown.highlighted = NO;
            weakSelf.isMaxTimeStop = YES;
            
            [weakSelf finishRecorded];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
       
            //NSLog(@"-->--> power:%f",peakPowerForChannel);    //声波强度
            
        };
        _voiceRecordHelper.maxRecordTime = 60;
    }
    return _voiceRecordHelper;
}


-(WKFRadarView *)radarView{                         // animation ---> step1.1
    if(_radarView == nil){
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat WH = 205;//[UIScreen mainScreen].bounds.size.width;
        CGFloat XX = screenW/2-WH/2;
        CGFloat YY = 260;
        
        _radarView = [[WKFRadarView alloc] initWithFrame:CGRectMake(XX, YY, WH, WH) andThumbnail:@"U6SoundAnimateView_bigSound1.png"];
        UIWindow * window = [UIApplication sharedApplication].windows.lastObject;
        [window addSubview:_radarView];
        [window bringSubviewToFront:_radarView];
    }
    return _radarView;
}


@end
