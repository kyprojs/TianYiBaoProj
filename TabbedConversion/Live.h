//
//  Live.h
//  TianYiBao
//
//  Created by pauling on 12-6-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Live : UIViewController {
    IBOutlet UITextField *userNameTF;
    IBOutlet UITextField *passwordTF;
}

@property (retain,nonatomic) IBOutlet UITextField *userNameTF;
@property (retain,nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)CancelBtnClick:(id)sender;
- (IBAction)LoginBtnClick:(id)sender;
- (IBAction)TextFileDoneEditing:(id)sender;
/////////////////////
/////////////

@end
