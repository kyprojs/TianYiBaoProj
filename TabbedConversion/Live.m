//
//  Live.m
//  TianYiBao
//
//  Created by pauling on 12-6-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Live.h"
#import "Utility.h"

@implementation Live

@synthesize userNameTF,passwordTF;

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

- (IBAction)CancelBtnClick:(id)sender {
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)LoginBtnClick:(id)sender {
    NSString *name = userNameTF.text;
//    NSString *pass = [Utility md5:passwordTF.text];
    
    NSString *notice = [[NSString alloc]init];
    
    if ([name length]==0) {
        notice = @"用户名不能为空！";
        [self performSelector:@selector(creatAlert:) withObject:notice];
    }else if([passwordTF.text length]==0){
        notice = @"密码不能为空！";
        [self performSelector:@selector(creatAlert:) withObject:notice];
    }
    
    
    [notice release];
}

- (IBAction)TextFileDoneEditing:(id)sender{
    [sender resignFirstResponder];
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


@end
