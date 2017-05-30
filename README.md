# ZYAudioRecorderWidget
an independent widget for audio recording, very easy to use
一个独立的录音按钮封装(自带->录音继续、结束的提示动画, 保存、时长、播放...)[写聊天专用哦^_^]
## Usage here
### - step1
```
#import "ZYVoiceView.h"     // usage of voice --- import header file
```
### - step2
```
    // ----------------- usage of voice begin ------------------
    CGFloat inputViewHeight = 45;
    // 输入工具条的frame
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height -
                                   inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);
    ZYVoiceView * voiceView = [[ZYVoiceView alloc]initWithFrame:inputFrame];    // __block
    WEAKSELF
    // 回调的voice block
    voiceView.zyVoiceCBBlock = ^(NSString *voicePath ,NSString *voiceDuration){
        STRONGSELF
        strongSelf.voicePath = voicePath;
        [strongSelf playVoiceAction];
        
        if([voiceDuration floatValue] < 1){
            
        }
        
    };
    [self.view addSubview:voiceView];
    // ----------------- usage of voice end ------------------

```

## To test recorded audio here
```
#import "XHVoiceCommonHelper.h" //测试save audio
#import "XHAudioPlayerHelper.h" //测试play audio
```
```
-(void)playVoiceAction{
    
    if([XHVoiceCommonHelper fileExistsAtPath:self.voicePath]){
        
     [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:self.voicePath toPlay:YES];
    }
}
```
