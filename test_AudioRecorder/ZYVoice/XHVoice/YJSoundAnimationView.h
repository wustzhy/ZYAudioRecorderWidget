//
//  YJSoundAnimationView.h
//
//  Created by liyy on 13-2-21.
//
//

#import <UIKit/UIKit.h>
//#import "YJTagView.h"

@protocol YJSoundAnimationViewDelegate <NSObject>
-(void)YJSoundAnimationViewClosed;
@end

@interface YJSoundAnimationView : UIView
{
    UIView          *_contentView;
    
    UIView          *_soundBgView;
    UIImageView     *_soundView;
    UIImageView     *_soundView2;
    UIView          *_backSoundView;
    
    UILabel         *_tipsLabel;
    
    UIImageView     *_delView;
    
    UIImageView     *_tipsView;
    
    UIImageView     *_waveView1;
    UIImageView     *_waveView2;
    UIImageView     *_waveView3;
    
    UILabel         *_secTagLabel;
    
    BOOL            _bAnimate;
}

@property(nonatomic) NSInteger iStatus;//view状态 0：录音 1：取消 2:录音时间太短
@property(nonatomic, assign) id<YJSoundAnimationViewDelegate> delegate;


-(void)setSecond:(int)sec volume:(float)vol;

-(void)setIStatus:(NSInteger)iStatus;

-(void)show;
-(void)hide;
-(void)hideAfterDelay:(NSTimeInterval)delay;
@end
