//
//  ViewController.m
//  test_AudioRecorder
//
//  Created by Ray on 2017/3/27.
//  Copyright © 2017年 DragonLi. All rights reserved.
//

#import "ViewController.h"
#import "ZYVoiceView.h"     // usage of voice --- import header file


#import "XHVoiceCommonHelper.h" //测试save audio
#import "XHAudioPlayerHelper.h" //测试play audio

// Size
#define MDK_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define MDK_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface ViewController ()///<XHMessageInputViewDelegate>

///// test
@property (nonatomic, copy) NSString *voicePath;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
    // test voice ---> play
    UIButton * playVoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, MDK_SCREEN_HEIGHT - 100, 100, 50)];
    playVoiceBtn.backgroundColor = [UIColor blueColor];
    [playVoiceBtn setTitle:@"play" forState:UIControlStateNormal];
    [playVoiceBtn addTarget:self action:@selector(playVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playVoiceBtn];
    
    //test voice file ---> delete
    UIButton * deleteVoice = [[UIButton alloc]initWithFrame:CGRectMake(50, MDK_SCREEN_HEIGHT - 100, 80, 50)];
    deleteVoice.backgroundColor = [UIColor blueColor];
    [deleteVoice setTitle:@"delete" forState:UIControlStateNormal];
    [deleteVoice addTarget:self action:@selector(deleteVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteVoice];
 
}


-(void)playVoiceAction{
    
    if([XHVoiceCommonHelper fileExistsAtPath:self.voicePath]){
        
     [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:self.voicePath toPlay:YES];
    }
}

-(void)deleteVoiceAction{
    [XHVoiceCommonHelper deleteFileAtPath:self.voicePath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
