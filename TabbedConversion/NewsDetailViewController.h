//
//  NewsDetailViewController.h
//  TianYiBao
//
//  Created by lin xiaoyu on 12-5-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface NewsDetailViewController : UIViewController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    UIWebView *webView;
    NSString *currentMainTab;
    NSString *currentSubTab;
    NSString *newsId;
    NSString *shareBody;
    NSString *shareThings;
}

@property (retain,nonatomic) NSString *shareThings;
@property (retain,nonatomic) NSString *shareBody;

-(NSString *)changeString:(NSString *)str;
-(void)setTitleAndContent:(NSString *)newsID tabWidget:(NSString*) mainTab  label:(NSString*) subTab newsTitle:(NSString*) title date:(NSString *)date source:(NSString *)source content:(NSString *)content;
@end
