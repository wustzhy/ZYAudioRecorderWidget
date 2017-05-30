//
//  UIView+Additions.m
//  MeYou
//
//  Created by hower on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+Additions.h"

#if !__has_feature(objc_arc)
#error no "objc_arc" compiler flag
#endif

@implementation UIView(U6)

+ (id)viewWithFrame:(CGRect)frame
{
    UIView *view = [[[self class] alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)width{
	return self.bounds.size.width;
}

-(CGFloat)height{
	return self.bounds.size.height;
}

-(CGFloat)left{
	return self.center.x - (self.width * 0.5f);
}

-(CGFloat)top{
	return self.center.y - (self.height * 0.5f);
}

-(CGFloat)right{
    return self.left + self.width;
}
-(CGFloat)buttom{
    return self.top + self.height;
}
- (CGFloat)midWidth
{
    return self.width * 0.5f;
}
- (CGFloat)midHeight
{
    return self.height * 0.5f;
}

-(void)removeAllSubviews{
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder])
    {
        return self;
    }
    else
    {
        NSArray *subViewArr = [self subviews];
        for (UIView *subView in subViewArr)
        {
            if ([subView isKindOfClass:[UIView class]])
            {
                UIView *subSubView = [subView findFirstResponder];
                if (subSubView)
                {
                    return subSubView;
                }
            }
        }
    }

    return nil;
}

+(UIView *)keyView
{
    UIWindow *w = [[UIApplication sharedApplication]keyWindow];
    if (w.subviews.count > 0)
    {
        return [w.subviews objectAtIndex:0];
    }
    else
    {
        return w;
    }
}

- (UIViewController *)getBelongViewController
{
    for (UIView* next = self; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
