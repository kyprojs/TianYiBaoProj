//
//  TabbedConversionAppDelegate.h
//  TabbedConversion
//
//  Created by lin xiaoyu on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>
#import "Login.h"

@interface TianYiBaoAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate,UINavigationControllerDelegate > {
    IBOutlet UITabBarController *tabBarController;
    IBOutlet Login *myLoginController;
}

-(void)showTabbar;
-(void)showLoginView;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet Login *myLoginController;

@end
