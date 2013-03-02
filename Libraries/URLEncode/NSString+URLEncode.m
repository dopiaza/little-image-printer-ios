//
//  NSString+URLEncode.m
//  DPZAPIKit
//
//  Created by David Wilkinson on 26/08/2012.
//  Copyright (c) 2012 David Wilkinson. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)


-(NSString*)urlEncode
{
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                        (__bridge CFStringRef)self,
                                                                                        NULL,
                                                                                        (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`",
                                                                                        CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return s;
}

-(NSString *)urlDecode
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
