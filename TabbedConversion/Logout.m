//
//  Logout.m
//  TianYiBao
//
//  Created by pauling on 12-6-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Logout.h"
#import "TianYiBaoAppDelegate.h"

@implementation Logout

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
    
//    TianYiBaoAppDelegate *appDelegate = (TianYiBaoAppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate showLoginView];
    // Do any additional setup after loading the view from its nib.
}

//- (void)viewWillAppear:(BOOL)animated{
//    TianYiBaoAppDelegate *appDelegate = (TianYiBaoAppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate showLoginView];
//}

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
