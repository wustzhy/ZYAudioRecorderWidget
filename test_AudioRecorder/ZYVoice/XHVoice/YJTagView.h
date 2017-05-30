//
//  YJTagView.h

//
//  Created by liyy on 12-12-18.
//
//

#import <UIKit/UIKit.h>
//#import "ZGImageView.h"
#import "UIView+Additions.h"

//用于包含图片和提示语的标签 
@interface YJTagView : UIView
{
    UIImageView     *_tagImageView;
    UILabel         *_tagLabel;
    
    NSInteger       _iModeType; 
}

@property(nonatomic, strong) UIImageView* tagImageView;
@property(nonatomic, strong) UILabel* tagLabel;
@property(nonatomic) NSInteger iMaxWidth;//最大宽度， 小于0时不限制
@property(nonatomic) NSInteger  iModeType;//0:(默认) 左边图片 右边文字  1：背景图片 上面文字 2:上面图片 下面文字

@end
