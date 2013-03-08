//
//  UIView+FirstResponder.m
//  go
//
//  Created by David Wilkinson on 08/07/2012.
//  Copyright (c) 2012 Lumen Services Limited. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)

-(BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) 
    {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) 
    {
        if ([subView findAndResignFirstResponder])
        return YES; 
    }
    return NO;
}

-(UIView *)findFirstResponder
{
    UIView *firstResponder = nil;
    if (self.isFirstResponder)
    {
        firstResponder = self;
    }
    if (!firstResponder)
    {
        for (UIView *subView in self.subviews)
        {
            firstResponder = [subView findFirstResponder];
            if (firstResponder)
            {
                break;
            }
        }
    }
    return firstResponder;
}

@end
