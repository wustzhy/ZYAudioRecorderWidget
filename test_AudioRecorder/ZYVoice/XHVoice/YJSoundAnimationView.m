//
//  YJSoundAnimationView.m

//
//  Created by liyy on 13-2-21.
//
//

#import "YJSoundAnimationView.h"
#import "UIView+Additions.h"

#if !__has_feature(objc_arc)
#error no "objc_arc" compiler flag
#endif

#define ANIMATE_VIEW_SIZE 230
#define PADDING 10
#define BUTTOM_PADDING 30
#define MAIN_VIEW_SIZE 120



#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]


@implementation YJSoundAnimationView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, ANIMATE_VIEW_SIZE, ANIMATE_VIEW_SIZE)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        //波纹底在最下面
        _waveView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatInput_record.png"]];
        _waveView1.frame = CGRectMake(0, 0, MAIN_VIEW_SIZE, MAIN_VIEW_SIZE);
        _waveView1.alpha = 0.4;
        [self addSubview:_waveView1];
        _waveView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatInput_record.png"]];
        _waveView2.frame = CGRectMake(0, 0, MAIN_VIEW_SIZE, MAIN_VIEW_SIZE);
        _waveView2.alpha = 0.4;
        [self addSubview:_waveView2];
        _waveView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatInput_record.png"]];
        _waveView3.frame = CGRectMake(0, 0, MAIN_VIEW_SIZE, MAIN_VIEW_SIZE);
        _waveView3.alpha = 0.4;
        [self addSubview:_waveView3];
        
        //背景
        _soundBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_VIEW_SIZE, MAIN_VIEW_SIZE)];
        _soundBgView.backgroundColor = RGBACOLOR(0xee, 0x45, 0x52, 0.9);
        _soundBgView.layer.cornerRadius = MAIN_VIEW_SIZE * 0.5;
        _soundBgView.center = CGPointMake(ANIMATE_VIEW_SIZE * 0.5, ANIMATE_VIEW_SIZE * 0.5);
        [self addSubview:_soundBgView];
        
        _waveView1.center = _soundBgView.center;
        _waveView2.center = _soundBgView.center;
        _waveView3.center = _soundBgView.center;
        
        //白色音叉
        _soundView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"U6SoundAnimateView_bigSound2.png"]];
        //红色音叉
        _soundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"U6SoundAnimateView_bigSound1.png"]];
        _soundView2.frame = CGRectMake((_soundBgView.width-_soundView2.width)/2,
                                       (_soundBgView.height-_soundView2.height)/2-PADDING,
                                       _soundView2.width,
                                       _soundView2.height);
        _backSoundView = [[UIView alloc]initWithFrame:_soundView2.frame];
        _backSoundView.backgroundColor = [UIColor clearColor];
        [_backSoundView addSubview:_soundView];
        _backSoundView.clipsToBounds = YES;
        _backSoundView.bounds = CGRectMake(0.0f, _soundView2.height, _soundView2.width, _soundView2.height);
        _backSoundView.frame = CGRectMake(_soundView2.left, _soundView2.top+_soundView2.height, _soundView2.width, _soundView2.height);
        
        [_soundBgView addSubview:_soundView2];//白色音叉
        [_soundBgView addSubview:_backSoundView];//红色音叉
        
        //提示语label
        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.left, self.left+self.height-BUTTOM_PADDING, self.width, 16)];
        _tipsLabel.center = CGPointMake(ANIMATE_VIEW_SIZE * 0.5, ANIMATE_VIEW_SIZE * 0.5 + 30);
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.text = @"向上滑动取消";//NSLocalizedString(@"CHATINPUT_SOUND_UP_CANCEL", @"向上滑动取消");
        [self addSubview:_tipsLabel];
        
        //删除垃圾桶
        _delView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chatInput_delete.png"]];
        _delView.frame = CGRectMake((self.width-_delView.width)/2, (self.height-_delView.height)/2-PADDING, _delView.width, _delView.height);
        _delView.hidden = YES;
        [self addSubview:_delView];
        
        //叹号
        _tipsView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_mic_warm.png"]];
        _tipsView.frame = CGRectMake((self.width-_tipsView.width)/2, (self.height-_tipsView.height)/2-PADDING, _tipsView.width, _tipsView.height);
        _tipsView.hidden = YES;
        [self addSubview:_tipsView];
        
        //秒数
        _secTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.left, self.left+self.height-BUTTOM_PADDING, self.width, 20)];
        _secTagLabel.center = CGPointMake(ANIMATE_VIEW_SIZE * 0.5, _soundBgView.top - 15);
        _secTagLabel.backgroundColor = [UIColor clearColor];
        _secTagLabel.textAlignment = NSTextAlignmentCenter;
        _secTagLabel.font = [UIFont systemFontOfSize:24];
        _secTagLabel.textColor = RGBACOLOR(0xee, 0x45, 0x52, 1);
        _secTagLabel.text = @"向上滑动取消";//NSLocalizedString(@"CHATINPUT_SOUND_UP_CANCEL", @"向上滑动取消");
        [self addSubview:_secTagLabel];
    }
    
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [self hide];
}

- (void)show
{
    UIView* keyView = nil;
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
//    if (keyWindow.subviews.count > 0)
//    {
//        keyView = [keyWindow.subviews objectAtIndex:0];
//    }
//    else
    {
        keyView = keyWindow;
    }
    
    CGRect bounds = keyView.bounds;
    _contentView = [[UIView alloc] initWithFrame:bounds];
	_contentView.backgroundColor = [UIColor clearColor];
    _contentView.contentMode = UIViewContentModeScaleToFill;
	_contentView.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleHeight |
                                     UIViewAutoresizingFlexibleBottomMargin);
    
    [keyView addSubview:_contentView];

    self.frame = CGRectMake((_contentView.width-self.width)/2, (_contentView.height-self.height)/2, self.width, self.height);
    _secTagLabel.text = @"";
    self.iStatus = 0;
    
    _bAnimate = YES;
    
    [self waveAnimate:_waveView1 delay:0];
    [self waveAnimate:_waveView2 delay:1.2];
    [self waveAnimate:_waveView3 delay:2.4];

    [_contentView addSubview:self];
}

- (void)hide
{
    _bAnimate = NO;
    
    if (_contentView != nil)
    {
        [_contentView removeFromSuperview];
        _contentView = nil;
        
        _backSoundView.bounds = CGRectMake(0.0f, _soundView2.height, _soundView2.width, _soundView2.height);
        _backSoundView.frame = CGRectMake(_soundView2.left, _soundView2.top+_soundView2.height, _soundView2.width, _soundView2.height);
        
        if ([self.delegate respondsToSelector:@selector(YJSoundAnimationViewClosed)])
        {
            [self.delegate YJSoundAnimationViewClosed];
        }
    }
}

- (void)waveAnimate:(UIView *)view delay:(float)delay
{   NSLog(@"1view.hidden = %zd",view.hidden);
    [UIView animateWithDuration:3.6
                          delay:delay
                        options:UIViewAnimationCurveEaseIn//UIViewAnimationOptionCurveEaseIn//UIViewAnimationCurveEaseIn
                     animations:^{
                         view.frame = self.bounds;
                         view.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         view.frame = CGRectMake(0, 0, MAIN_VIEW_SIZE, MAIN_VIEW_SIZE);
                         view.center = _soundBgView.center;
                         view.alpha = 0.4;
                         if (_bAnimate)
                         {   NSLog(@"1view.hidden = %zd",view.hidden);
                             [self waveAnimate:view delay:0];
                         }
                         else
                         {
                             [self waveAnimateStop];
                         }
                     }];
}

- (void)waveAnimateStop
{
    [_waveView1.layer removeAllAnimations];
    [_waveView2.layer removeAllAnimations];
    [_waveView3.layer removeAllAnimations];
    _waveView1.frame = CGRectMake(0, 0, MAIN_VIEW_SIZE, MAIN_VIEW_SIZE);
    _waveView2.frame = CGRectMake(0, 0, MAIN_VIEW_SIZE, MAIN_VIEW_SIZE);
    _waveView3.frame = CGRectMake(0, 0, MAIN_VIEW_SIZE, MAIN_VIEW_SIZE);
    _waveView1.center = _soundBgView.center;
    _waveView2.center = _soundBgView.center;
    _waveView3.center = _soundBgView.center;
}

-(void)hideAfterDelay:(NSTimeInterval)delay
{
    _contentView.userInteractionEnabled = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

-(void)setSecond:(int)sec volume:(float)vol;
{
    vol = vol > 1 ? 1 : vol;
//    float percent = (1.0f + vol)/2.0f;
//    _backSoundView.bounds = CGRectMake(0.0f, _soundView2.height*(1.0-percent), _soundView2.width, _soundView2.height);
//    _backSoundView.frame = CGRectMake(_soundView2.left, _soundView2.top+_soundView2.height*(1.0-percent), _soundView2.width, _soundView2.height);
    float percent = vol / 1;
    _backSoundView.bounds = _soundView2.bounds;
    _backSoundView.frame = _soundView2.frame;
    _backSoundView.alpha = percent;
    NSLog(@"%f",_backSoundView.alpha);
    if (sec <= 0)
    {
        _secTagLabel.text = @"";
    }
    else
    {
        _secTagLabel.text = [NSString stringWithFormat:@"%d\"", sec];
    }
}

-(void)setIStatus:(NSInteger)iStatus
{
    if (_iStatus == iStatus)
    {
        return;
    }
    
    _iStatus = iStatus;
    if (_iStatus == 0)
    {
        _delView.hidden = YES;
        _soundBgView.hidden = NO;
        _soundView2.hidden = NO;
        _backSoundView.hidden = NO;
        
        _tipsView.hidden = YES;
        _secTagLabel.hidden = NO;
        
        _tipsLabel.text = @"向上滑动取消";//NSLocalizedString(@"CHATINPUT_SOUND_UP_CANCEL", @"向上滑动取消");
        
        _soundBgView.backgroundColor = RGBACOLOR(0xee, 0x45, 0x52, 0.9);
        
        _waveView1.hidden = NO;
        _waveView2.hidden = NO;
        _waveView3.hidden = NO;
    }
    else if (_iStatus == 1)
    {
        _delView.hidden = NO;
        _soundBgView.hidden = NO;
        _soundView2.hidden = YES;
        _backSoundView.hidden = YES;
        
        _tipsView.hidden = YES;
        _secTagLabel.hidden = YES;
        
        _tipsLabel.text = @"松开取消";// NSLocalizedString(@"MEET_MIC_BUTTON_CANCEL", @"松开取消");
        
        _soundBgView.backgroundColor = RGBACOLOR(0x00, 0x00, 0x00, 0.9);
        
        _waveView1.hidden = YES;
        _waveView2.hidden = YES;
        _waveView3.hidden = YES;
    }
    else if (_iStatus == 2)
    {
        _delView.hidden = YES;
        _soundBgView.hidden = NO;
        _soundView2.hidden = YES;
        _backSoundView.hidden = YES;
        _tipsView.hidden = NO;
        _secTagLabel.hidden = YES;
        
        _tipsLabel.text = @"录音时间太短"; //NSLocalizedString(@"RECORD_TOO_SHORT", @"录音时间太短");
        
        _soundBgView.backgroundColor = RGBACOLOR(0xee, 0x45, 0x52, 0.9);
        
        _waveView1.hidden = YES;
        _waveView2.hidden = YES;
        _waveView3.hidden = YES;
    }
}

@end
