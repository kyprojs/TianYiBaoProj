//
//  Register.h
//  TianYiBao
//
//  Created by pauling on 12-6-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Login;

@interface Register : UIViewController <UITextFieldDelegate>{
    IBOutlet UITextField *emailPreText;
    IBOutlet UITextField *emailLastText;
    IBOutlet UITextField *nickNameText;
    IBOutlet UITextField *passwordText;
    IBOutlet UITextField *rePasswordText;
    
    IBOutlet Login *loginController;
}

@property (retain,nonatomic) IBOutlet UITextField *emailPreText;
@property (retain,nonatomic) IBOutlet UITextField *emailLastText;
@property (retain,nonatomic) IBOutlet UITextField *nickNameText;
@property (retain,nonatomic) IBOutlet UITextField *passwordText;
@property (retain,nonatomic) IBOutlet UITextField *rePasswordText;
@property (retain,nonatomic) IBOutlet Login *loginController;


-(BOOL)textFieldShouldReturn:(id)sender;
-(BOOL)textFieldShouldBeginEditing:(id)sender;
- (IBAction)ShowUserProtocol:(id)sender;
- (IBAction)UserRegiseter:(id)sender;
- (IBAction)returnToLogin:(id)sender;

@end
