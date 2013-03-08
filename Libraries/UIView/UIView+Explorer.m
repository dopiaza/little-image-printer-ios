//
//  UIView+Explorer.m
//  Little Image Printer
//
//  Created by David Wilkinson on 08/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "UIView+Explorer.h"

@implementation UIView (Explorer)

+ (NSString *)viewDetails:(UIView *)view level:(int)level
{
    NSMutableString *s = [NSMutableString string];    
    NSString *indent = [UIView indentStringForViewDetailsWithLevel:level];
    [s appendFormat:@"%@%@: %@\n", indent, [[view class] description], NSStringFromCGRect([view frame])];

    for (UIView *subview in [view subviews])
    {
        [s appendString:[UIView viewDetails:subview level:(level + 1)]];
    }
    
    return s;
}

+ (NSString *)indentStringForViewDetailsWithLevel:(int)level
{
    NSMutableString *s = [NSMutableString string];
    for (int i = 0; i < level; i++)
    {
        [s appendString:@"    "];
    }
    return s;
}

- (void)viewHierarchy
{
    NSString *s = [UIView viewDetails:self level:0];
    printf("%s", [s cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
