//
//  DPZPrintCodeViewController.h
//  Little Image Printer
//
//  Created by David Wilkinson on 09/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPZPrintCodeViewController : UIViewController
<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
