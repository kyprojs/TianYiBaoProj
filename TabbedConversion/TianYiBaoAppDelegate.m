//
//  TabbedConversionAppDelegate.m
//  TabbedConversion
//
//  Created by lin xiaoyu on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TianYiBaoAppDelegate.h"
#import "SBJson.h"
#import "Utility.h"
#import "LoadNews.h"
#import "GlobalVariableStore.h"
#import "Login.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation TianYiBaoAppDelegate


@synthesize window=_window;
@synthesize tabBarController,myLoginController;

-(void)initSysParam{
    [GlobalVariableStore sharedInstance].provinceId=@"1";
    [GlobalVariableStore sharedInstance].city=@"1";
    [GlobalVariableStore sharedInstance].cityName=@"福州";
    
}

/*
//检测网络是否可用
- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    if ([self connectedToNetwork]) {
//
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络链接失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
    
    
    
    
    //去除Edit按钮需要将导航栏的控制器代理给自己，在.h文件要遵循导航控制器的协议
    tabBarController.moreNavigationController.delegate = self;
    
    UINavigationBar *moreNavigationBar = tabBarController.moreNavigationController.navigationBar;
    moreNavigationBar.tintColor = RGBA(200, 0, 0, 1);
    //moreNavigationBar.barStyle=UIStatusBarStyleBlackTranslucent;//设置moretab后面导航栏的风格为黑色风格.
    moreNavigationBar.topItem.title = @"更多";//设置moretab后面的导航栏的名称;
    
    // Override point for customization after application launch.
    
//    [self.window addSubview:tabBarController.view];
    
    [self.window addSubview:myLoginController.view];//添加登入的页面
    
    [self.window makeKeyAndVisible];
    
    [self initSysParam];
    return YES;
    
    
    
    
    
       /*
    //NSString *province=@"福建";
    //NSString *city=@"福州";
    //NSData *provData=[province dataUsingEncoding:<#(NSStringEncoding)#>
    //NSString * strURL=@"http://new3g.tianyibao.cn:9080/new3g/android/IarCallMS.jsp?actType=updateMyLocation&id=914&province=福建&city=福州";
    NSString * strURL=@"http://new3g.tianyibao.cn:9080/new3g/android/IarCallMS.jsp?";
    
    NSString *pass= [Utility md5:@"qqqqqq"];
    NSString *province=@"actType=province&province_id=1&province_name=福建";
    //NSString * strURL=@"http://new3g.tianyibao.cn:9080/new3g/android/IarCallMS.jsp?actType=verify&loginUsername=914090805@qq.com&loginPassword=";
    //strURL=[strURL stringByAppendingString:pass];
    strURL=[strURL stringByAppendingString:province];
    
   NSString *encodeURL;
   encodeURL=[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  //  encodeURL=strURL;
    //NSStringEncoding strEncode=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingHZ_GB_2312);

                                  
    NSLog(@"%@",encodeURL);
    
    NSURL *url=[NSURL URLWithString: encodeURL];
    
    //NSURL *url=[NSURL URLWithString: @"http://new3g.tianyibao.cn:9080/new3g/android/IarCallMS.jsp?actType=versionCode&application=yingyan"]; 
    //NSString *url=@"http://new3g.tianyibao.cn:9080/new3g/android/IarCallMS.jsp?tabWidget=tab_government&label=tab_government_note&province_id=福建&area_code=begin_index=0&end_index=3";
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url   encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@",jsonString); 
    id *jsonValue = [jsonString JSONValue];
    NSLog(@"test   %@", [jsonValue description]);
    */
    
}



//注：此方法用于将更多右边的edit按钮去除
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    UINavigationItem *morenavitem = navigationController.navigationBar.topItem;

    morenavitem.rightBarButtonItem.title = @"编辑";
}


////选项卡选择触发事件
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    if (tabBarController.selectedIndex == 0) {
//        NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaa%@",[GlobalVariableStore sharedInstance].city);
//    }else if(tabBarController.selectedIndex == 1){
//        NSLog(@"nnnnnnnnnnnnnnnnnnnnnnnn%@",[GlobalVariableStore sharedInstance].city);
//    }else if(){
//        
//        [self showLoginView];
////        [self.window addSubview:myLoginController.view];
//    }
//}


//设置登入后显示为第一个选项栏
-(void)showTabbar{
    [myLoginController.view removeFromSuperview];
    tabBarController.selectedIndex = 0;
    [self.window addSubview:tabBarController.view];
}

//注销时显示的是登录视图
-(void)showLoginView{
    [tabBarController.view removeFromSuperview];
    [self.window addSubview:myLoginController.view];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


//检测网络是否可用



- (void)dealloc
{
    [tabBarController release];
    [myLoginController release];
    [_window release];
    [super dealloc];
}

@end
