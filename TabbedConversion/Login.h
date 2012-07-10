//
//  Login.h
//  TianYiBao
//
//  Created by pauling on 12-6-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@class Register;

@interface Login : UIViewController {
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    IBOutlet Register *registController;
}

@property (retain,nonatomic) IBOutlet UITextField *userName;
@property (retain,nonatomic) IBOutlet UITextField *password;
@property (retain,nonatomic) IBOutlet Register *registController;
- (IBAction)Regist:(id)sender;
- (IBAction)Login:(id)sender;
- (IBAction)TextFileDoneEditing:(id)sender;

@end
