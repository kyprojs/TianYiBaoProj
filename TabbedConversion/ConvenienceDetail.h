//
//  ConvenienceDetail.h
//  TianYiBao
//
//  Created by pauling on 12-6-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConvenienceDetail : UIViewController {
    IBOutlet UIWebView *webView;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIBarItem *barItem;
    NSString *webSite;
}

@property (retain,nonatomic) IBOutlet UIWebView *webView;
@property (retain,nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain,nonatomic) IBOutlet UIBarItem *barItem;
@property (retain,nonatomic) NSString *webSite;
- (IBAction)backToList:(id)sender;

@end
