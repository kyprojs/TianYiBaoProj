//
//  Register.m
//  TianYiBao
//
//  Created by pauling on 12-6-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Register.h"
#import "Login.h"

@implementation Register
@synthesize emailPreText,emailLastText,nickNameText,passwordText,rePasswordText,loginController;

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
    [emailPreText release];
    [emailLastText release];
    [nickNameText release];
    [passwordText release];
    [rePasswordText release];
    [loginController release];
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


//调整软件盘出现时，输入框的位置，以免被遮挡
-(BOOL)textFieldShouldReturn:(id)sender{
    self.view.center = CGPointMake(160,250);
    [sender resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(id)sender{
    self.view.center=CGPointMake(self.view.center.x,160);
    return YES;
}

- (IBAction)ShowUserProtocol:(id)sender {
    UIAlertView *userProtocol = [[UIAlertView alloc]initWithTitle:@"用户协议" message:@"这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议这是用户协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [userProtocol show];
    [userProtocol release];
}


//输入校验
- (IBAction)UserRegiseter:(id)sender {
//    NSString *message = [[NSString alloc]init];
//    
//    
//    
//    if ([emailPreText.text length]==0) {
//        message = @"请输入邮箱！";
//        [self performSelector:@selector(creatAlert:) withObject:message];
//    }else if([emailLastText.text length]==0){
//        message = @"请输入邮箱后缀！";
//        [self performSelector:@selector(creatAlert:) withObject:message];
//    }else if([nickNameText.text length]==0){
//        message = @"请输入您的用户名！";
//        [self performSelector:@selector(creatAlert:) withObject:message];
//    }else if([passwordText.text length]==0){
//        message = @"请输入密码！";
//        [self performSelector:@selector(creatAlert:) withObject:message];
//    }else if([rePasswordText.text length]==0){
//        message = @"请输入确认密码";
//        [self performSelector:@selector(creatAlert:) withObject:message];
//    }else if(![rePasswordText.text isEqualToString:passwordText.text]){
//        message = @"两次输入密码不一致，请重新输入！";
//        [self performSelector:@selector(creatAlert:) withObject:message];
//    }
//    
//    
//    
//    
//    [message release];
    
    
    
}

//返回登录页面
- (IBAction)returnToLogin:(id)sender {
    [self presentModalViewController:loginController animated:NO];
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

@end
