//
//  WKFRadarView.m
//  RadarDemo
//
//  Created by apple on 16/1/13.

//

#import "WKFRadarView.h"
#import "UILabel+ZYCustom.h"
#import "UIView+MJExtension.h"
#import "GTCommont.h"


@interface KFRadarButton ()

@end

@implementation KFRadarButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
    }
    return self;
}
-(void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window != nil) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 1;
        }];
    }
}
-(void)removeFromSuperview
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1];
    self.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(callSuperRemoveSuperView)];
    [UIView commitAnimations];
    
}
-(void)callSuperRemoveSuperView
{
    [super removeFromSuperview];
}

@end

@interface WKFRadarView()
{
    CGSize itemSize;
    NSMutableArray *items ;
}

@property (nonatomic,weak)CALayer *animationLayer;
@property (nonatomic, strong) CALayer * pulsingLayer;


@property (nonatomic, strong) UIView * picContentView;

@property (nonatomic, strong) UIImageView * sound1_imgV;
//@property (nonatomic, strong) UIImageView * sound2_imgV;
// 文字提示
@property (nonatomic, strong) UILabel * des_label;
// 录音时长
@property (nonatomic, strong) UILabel * time_label;

@end

@implementation WKFRadarView
-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl
{
    if (self = [super initWithFrame:frame]) {
        //当重后台进入前台，防止假死状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resume) name:@"PulsingRadarView_animation" object:nil];
        self.backgroundColor = [UIColor clearColor];
        items = [[NSMutableArray alloc]init];
        itemSize = CGSizeMake(40, 40);
        
        // 创建○view
        CGRect rect = frame;
        CGRect thumbnailRect = CGRectMake(0, 0, GTFixWidthFlaot(109), GTFixWidthFlaot(109));
        thumbnailRect.origin.x = (rect.size.width - thumbnailRect.size.width)/2.0;
        thumbnailRect.origin.y = (rect.size.height - thumbnailRect.size.height)/2.0;
        self.picContentView = [[UIView alloc]initWithFrame:thumbnailRect];
        self.picContentView.backgroundColor = ZHFColorRGB(74,73,74,0.80);
        self.picContentView.layer.cornerRadius = thumbnailRect.size.width/2;
        self.picContentView.layer.masksToBounds = YES;
        [self addSubview:self.picContentView];
        
        // 喇叭图 or 删图
        self.sound1_imgV = [[UIImageView alloc]initWithFrame:CGRectMake(GTFixWidthFlaot(38), GTFixHeightFlaot(22), GTFixWidthFlaot(32), GTFixHeightFlaot(48))];
        [self.sound1_imgV setImage:[UIImage imageNamed:@"U6SoundAnimateView_bigSound1.png"]];//voiceIconzy UI图没标注
        [self.picContentView addSubview:self.sound1_imgV];
        // 文字提示
        self.des_label = [UILabel NewLabelWithBackColor:[UIColor clearColor]
                                                   text:@"向上滑动取消"
                                                 fontSz:GTFixWidthFlaot(12)
                                               fontName:@"PingFangSC-Regular"
                                              textColor:[UIColor whiteColor]];
        self.des_label.textAlignment = NSTextAlignmentCenter;
        CGFloat centerX = self.picContentView.bounds.size.width/2;
        CGFloat centerY = CGRectGetMaxY(self.sound1_imgV.frame) + GTFixWidthFlaot(12);
        self.des_label.center = CGPointMake(centerX, centerY);
        [self.picContentView addSubview:self.des_label];
        
        // 录了多久了
        self.time_label = [UILabel NewLabelWithBackColor:[UIColor clearColor]
                                                    text:@"sec\""
                                                  fontSz:GTFixWidthFlaot(15)
                                                fontName:@"PingFangSC-Regular"
                                               textColor:[UIColor whiteColor]];
        self.time_label.textAlignment = NSTextAlignmentCenter;
        CGFloat centerXX = self.bounds.size.width/2;
        CGFloat centerYY = self.picContentView.frame.origin.y - self.time_label.bounds.size.height - GTFixHeightFlaot(4);
        self.time_label.center = CGPointMake(centerXX, centerYY);
        [self addSubview:self.time_label];        //暂不用
        
        //self.thumbnailImage = [UIImage imageNamed:thumbnailUrl];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor clearColor]setFill];
    UIRectFill(rect);
    NSInteger pulsingCount = 3;
    double animationDuration = 4;
    
    CALayer * animationLayer = [[CALayer alloc]init];
    self.animationLayer = animationLayer;
    
    for (int i = 0; i < pulsingCount; i++) {
        //CALayer * pulsingLayer = [[CALayer alloc]init];
        _pulsingLayer = [[CALayer alloc]init];
        _pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        _pulsingLayer.backgroundColor = ZHFColorRGB(74,73,74,0.80).CGColor;//[UIColor colorWithRed:92.0/255.0 green:181.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
        _pulsingLayer.borderColor = ZHFColorRGB(74,73,74,0.80).CGColor;//[UIColor colorWithRed:92.0/255.0 green:181.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
        _pulsingLayer.borderWidth = 1.0;
        _pulsingLayer.cornerRadius = rect.size.height/2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.fillMode = kCAFillModeBoth;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration/(double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE_VAL;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:109.0/205.0]; //0.2 //
        scaleAnimation.toValue = [NSNumber numberWithDouble:1.0];
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[[NSNumber numberWithDouble:1.0],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.0]];
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [_pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:_pulsingLayer];
    }
    self.animationLayer.zPosition = -1;//重新加载时，使动画至底层
    [self.layer addSublayer:self.animationLayer];
    
    CALayer * roundLayer = [[CALayer alloc]init];
    roundLayer.zPosition =  -1;
    [self.layer addSublayer:roundLayer];
//    CALayer * thumbnailLayer = [[CALayer alloc]init];
//    thumbnailLayer.backgroundColor = [UIColor whiteColor].CGColor;
//    //CGRect thumbnailRect = CGRectMake(0, 0, rect.size.height/4, rect.size.height/4);
//    CGRect thumbnailRect = CGRectMake(0, 0, rect.size.height*109/205, rect.size.height*109/205);
//    //thumbnailRect.origin.x = (rect.size.width - thumbnailRect.size.width)/2.0;
//    //thumbnailRect.origin.y = (rect.size.height - thumbnailRect.size.height)/2.0;
//    thumbnailRect.origin.x = (rect.size.width - thumbnailRect.size.width)/2.0;
//    thumbnailRect.origin.y = (rect.size.height - thumbnailRect.size.height)/2.0;
//    thumbnailLayer.frame = thumbnailRect;
//    //thumbnailLayer.cornerRadius = rect.size.height/8;
//    thumbnailLayer.cornerRadius = thumbnailRect.size.height/2;
//    thumbnailLayer.borderWidth = 1.0;
//    thumbnailLayer.masksToBounds = YES;
//    thumbnailLayer.borderColor = [UIColor whiteColor].CGColor;
//    UIImage * thumbnail = self.thumbnailImage;
//    thumbnailLayer.contents = (id)thumbnail.CGImage;
//    thumbnailLayer.zPosition = -1;
//    [self.layer addSublayer:thumbnailLayer];
}

- (void)stopAnimating{
    //[self.pulsingLayer removeAllAnimations];
    //self.pulsingLayer.hidden = YES;   //无效!
    self.animationLayer.hidden = YES;   //隐藏动画 有效!
    [self.sound1_imgV setImage:[UIImage imageNamed:@"chatInput_delete.png"]];
    self.des_label.text = @"松开取消";
    self.time_label.hidden = YES;
}

-(void)goonAnimating{
    //self.pulsingLayer.hidden = NO;
    self.animationLayer.hidden = NO;
    [self.sound1_imgV setImage:[UIImage imageNamed:@"U6SoundAnimateView_bigSound1.png"]];//voiceIconzy
    self.des_label.text = @"向上滑动取消";
    self.time_label.hidden = NO;
}

-(void)addOrReplaceItem
{
    NSInteger maxCount = 6;
    KFRadarButton *prButton = [[KFRadarButton alloc]initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    [prButton setImage:[UIImage imageNamed:@"default_portrait"] forState:UIControlStateNormal];
    prButton.layer.cornerRadius = 20;
    prButton.layer.masksToBounds = YES;
    
    do {
        CGPoint point = [self generateCenterPointInRadar];
        prButton.center = CGPointMake(point.x, point.y);
        
    } while ([self itemFrameIntersectsInOtherItem:prButton.frame]);
    
    [self addSubview:prButton];
    [items addObject:prButton];
    
    if (items.count > maxCount) {
        UIView * view = items[0];
        [view removeFromSuperview];
        [items removeObject:view];
    }
}

-(BOOL)itemFrameIntersectsInOtherItem:(CGRect)frame
{
    for (KFRadarButton *item in items) {
        if (CGRectIntersectsRect(item.frame, frame)) {
            return YES;
        }
    }
    return NO;
}

-(CGPoint)generateCenterPointInRadar
{
    double angle = arc4random()%360;
    double radius = ((NSInteger)arc4random()) % ((NSInteger)((self.bounds.size.width - itemSize.width)/2));
    double x = cos(angle) * radius;
    double y = sin(angle) * radius;
    return CGPointMake(x + self.bounds.size.width/2, y + self.bounds.size.height/2);
    
}

-(void)resume
{
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
        [self setNeedsDisplay];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
