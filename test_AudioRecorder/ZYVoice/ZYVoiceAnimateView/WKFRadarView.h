//
//  WKFRadarView.h
//  RadarDemo
//
//  Created by apple on 16/1/13.

//

#import <UIKit/UIKit.h>

@interface KFRadarButton :UIButton

@end

@interface WKFRadarView : UIView
@property (nonatomic,strong)UIImage *thumbnailImage;
-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl;
-(void)addOrReplaceItem;

-(void)stopAnimating;
-(void)goonAnimating;

@end
