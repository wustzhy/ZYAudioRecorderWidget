//
//  UIView+Additions.h
//  MeYou
//
//  Created by hower on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(U6)

+ (id)viewWithFrame:(CGRect)frame;

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)left;
- (CGFloat)top;
- (CGFloat)right;
- (CGFloat)buttom;
- (CGFloat)midWidth;
- (CGFloat)midHeight;
- (void)removeAllSubviews;

- (UIView *)findFirstResponder;

+ (UIView *)keyView;

- (UIViewController *)getBelongViewController;

@end
