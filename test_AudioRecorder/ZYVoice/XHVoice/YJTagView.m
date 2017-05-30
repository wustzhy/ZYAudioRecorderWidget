//
//  YJTagView.m

//
//  Created by liyy on 12-12-18.
//
//

#import "YJTagView.h"

#define PADDING 2

@implementation YJTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _tagImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
         [self addSubview:_tagImageView];
        
        
        _tagLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _tagLabel.backgroundColor = [UIColor clearColor];
        self.iMaxWidth = -1;
        _iModeType = 0;
       
        [self addSubview:_tagLabel];
    }
    return self;
}

-(void)setIModeType:(NSInteger)iModeType
{
    if (iModeType != _iModeType)
    {
        _iModeType = iModeType;
        
        [self sizeToFit];
    }
}

-(void)dealloc
{
    NSLog(@"--%s",__func__);
}

-(void)sizeToFit
{
    if (_iModeType == 0)//左边文字， 右边图片
    {
        [_tagImageView sizeToFit];
        _tagLabel.frame = CGRectZero;
        [_tagLabel sizeToFit];
        
        CGFloat fHeight = _tagImageView.height;
        if (fHeight < _tagLabel.height)
        {
            fHeight = _tagLabel.height;
        }
        
        CGFloat fTop = (fHeight - _tagImageView.height)/2;
        _tagImageView.frame = CGRectMake(0, fTop, _tagImageView.width, _tagImageView.height);
        
        fTop = (fHeight - _tagLabel.height)/2;
        
        if (self.iMaxWidth > 0
            && _tagLabel.width > self.iMaxWidth)
        {
            _tagLabel.frame = CGRectMake(_tagImageView.left+_tagImageView.width+PADDING, fTop, self.iMaxWidth, _tagLabel.height);
        }
        else
        {
            _tagLabel.frame = CGRectMake(_tagImageView.left+_tagImageView.width+PADDING, fTop, _tagLabel.width, _tagLabel.height);
        }
        
        self.frame = CGRectMake(self.left, self.top, (_tagImageView.width+_tagLabel.width+PADDING), fHeight);
        
    }
    else if (_iModeType == 1)//底图图片， 上面文字
    {       
        _tagLabel.frame = CGRectZero;
        [_tagLabel sizeToFit];
        
        _tagImageView.frame = CGRectMake(0, 0, self.width, self.height);
        
        CGSize size = _tagLabel.frame.size;
        
        if (self.iMaxWidth > 0
            && _tagLabel.width > self.iMaxWidth)
        {
            size.width = self.iMaxWidth;
        }
        
        _tagLabel.frame = CGRectMake((self.width-size.width)/2, (self.height-size.height)/2, size.width, size.height);
    }
    else//_iModeType == 2//上面图片， 下面文字
    {
        [_tagImageView sizeToFit];
        _tagLabel.frame = CGRectZero;
        [_tagLabel sizeToFit];
        
        CGFloat fWidth = _tagLabel.width;
        if (fWidth < _tagImageView.width)
        {
            fWidth = _tagImageView.width;
        }
        
        _tagImageView.frame = CGRectMake((fWidth-_tagImageView.width)/2, 0, _tagImageView.width, _tagImageView.height);
        _tagLabel.frame = CGRectMake((fWidth-_tagLabel.width)/2, _tagImageView.height+1, _tagLabel.width, _tagLabel.height);
                
        self.frame = CGRectMake(self.left, self.top, fWidth, _tagImageView.height+_tagLabel.height+1);
    }
}
@end
