/*
  The Name Of The Project：test_AudioRecorder
  The File Name：ZYVoiceView.hh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/29.
  Copyright ：  Copyright © 2016年 . All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import <UIKit/UIKit.h>

typedef void(^ZYVoiceCBBlock)(NSString *voicePath ,NSString*voiceDuration);


@interface ZYVoiceView : UIView


@property (nonatomic, copy) ZYVoiceCBBlock zyVoiceCBBlock;




@end
