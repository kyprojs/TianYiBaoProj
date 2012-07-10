//
//  Login.m
//  TianYiBao
//
//  Created by pauling on 12-6-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Login.h"
#import "Utility.h"
#import "Register.h"
#import "LoadNews.h"
#import "TianYiBaoAppDelegate.h"
#import "GlobalVariableStore.h"

@implementation Login

@synthesize userName,password,registController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [userName release];
    [password release];
    [registController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Regist:(id)sender {
    [self presentModalViewController:registController animated:NO];
}

- (IBAction)Login:(id)sender {
    NSString *name = userName.text;
    NSString *pass = [Utility md5:password.text];
    
    NSString *notice = [[NSString alloc]init];
    
    if ([name length]==0) {
        notice = @"用户名不能为空！";
        [self performSelector:@selector(creatAlert:) withObject:notice];
    }else if([password.text length]==0){
        notice = @"密码不能为空！";
        [self performSelector:@selector(creatAlert:) withObject:notice];
    }
    
    NSMutableDictionary *resultDic = [LoadNews UserLoginByName:name Password:pass];
    
    NSString *result = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"result"]];
    
    NSLog(@"------------%@",result);
    
    if ([result length]!=0&&[result isEqualToString:@"1"]) {
        [GlobalVariableStore sharedInstance].nickName = [resultDic objectForKey:@"nick_name"];
        
        TianYiBaoAppDelegate *appDelegate = (TianYiBaoAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showTabbar];
    }else{
        notice = @"用户名或者密码错误";
        [self performSelector:@selector(creatAlert:) withObject:notice];
    }
    
    
//    NSString *uid = [resultDic objectForKey:@"uid"];
//    NSString *nickName = [resultDic objectForKey:@"nick_name"];
//    NSString *areaCode = [resultDic objectForKey:@"area_code"];
    
    
    NSLog(@"%@,%@",name,pass);

    [notice release];
}



//创建一个AlertView
- (void) creatAlert:(NSString *)message{
    UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
    [infoAlert show];
    [self performSelector:@selector(dimissAlert:) withObject:infoAlert afterDelay:1.5];
}

- (void) dimissAlert:(UIAlertView *)alert{
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        [alert release];
    }
}


- (IBAction)TextFileDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

@end
