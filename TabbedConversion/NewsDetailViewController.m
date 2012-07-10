//
//  NewsDetailViewController.m
//  TianYiBao
//
//  Created by lin xiaoyu on 12-5-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "LoadNews.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GlobalVariableStore.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation NewsDetailViewController
@synthesize shareThings,shareBody;

-(NSString *)changeString:(NSString *)str{
    NSString *code = @"";
    
    if([str isEqualToString:@"tab_government"])
        code=@"0";
    else if([str isEqualToString:@"tab_livelihood"])
        code=@"2";
    else if([str isEqualToString:@"tab_selects"])
        code=@"1";
    else if([str isEqualToString:@"tab_finance"])
        code=@"3";
    else if([str isEqualToString:@"tab_grouppurchase"])
        code=@"5";
    else if([str isEqualToString:@"tab_government_mess"])
        code=@"1";
    else if([str isEqualToString:@"tab_government_news"])
        code=@"2";
    else if([str isEqualToString:@"tab_government_notice"])
        code=@"0";
    else if([str isEqualToString:@"tab_government_major"])
        code=@"3";
    else if([str isEqualToString:@"tab_livelihood_atten"])
        code=@"0";
    else if([str isEqualToString:@"tab_livelihood_health"])
        code=@"5";
    else if([str isEqualToString:@"tab_livelihood_it"])
        code=@"2";
    else if([str isEqualToString:@"tab_livelihood_sport"])
        code=@"4";
    else if([str isEqualToString:@"tab_livelihood_straits"])
        code=@"1";
    else if([str isEqualToString:@"tab_livelihood_teach"])
        code=@"3";
    else if([str isEqualToString:@"tab_government_corporation"])
        code=@"2";
    else if([str isEqualToString:@"tab_government_people"])
        code=@"0";
    else if([str isEqualToString:@"tab_government_public"])
        code=@"1";
    else if([str isEqualToString:@"tab_government_corporation"])
        code=@"2";
    else if([str isEqualToString:@"tab_finance_data"])
        code=@"2";
    else if([str isEqualToString:@"tab_finance_debenture"])
        code=@"4";
    else if([str isEqualToString:@"tab_finance_fof"])
        code=@"3";
    else if([str isEqualToString:@"tab_finance_news"])
        code=@"0";
    else if([str isEqualToString:@"tab_grouppurchase_books"])
        code=@"1";
    else if([str isEqualToString:@"tab_grouppurchase_yi"])
        code=@"0";
    else
        code=str;
    
    return code;
}


-(void)setTitleAndContent:(NSString *)newsID tabWidget:(NSString*) mainTab  label:(NSString*) subTab newsTitle:(NSString*) title date:(NSString *)date source:(NSString *)source content:(NSString *)content{
    
    newsId=newsID;
    currentMainTab=mainTab;
    currentSubTab=subTab;
    
    //load uiwebview below
    CGRect webViewRect=CGRectMake(0, 0, 320, 416);
    webView=[[UIWebView alloc]initWithFrame:webViewRect];
    [self.view addSubview:webView];
    
    NSMutableString * allString=[[NSMutableString alloc]init];
    [allString appendString:@"<center><font size=3><b>"];
    [allString appendString:title];
    [allString appendString:@"</b></font></center><br>"];
    [allString appendString:@"发布日期："];
    [allString appendString:date];
    [allString appendString:@"   "];
    [allString appendString:source];
    [allString appendString:@"<hr>"];
    [allString appendString:content];
    
   // NSLog(@"all string :%@",allString  );
    
    [webView loadHTMLString:allString baseURL:nil];
    
    NSString *pre = @"#天翼宝发现好文章#<";
    
    shareThings = [[pre stringByAppendingString:title] stringByAppendingString:@">"];
    
    NSString *first = [self changeString:mainTab];
    NSString *second = [self changeString:subTab];
    NSString *urlPre = @"http://new3g.tianyibao.cn:9080/new3g/android/shownews.jsp?";
    
    shareBody = [urlPre stringByAppendingFormat:@"c=%@&l=%@&d=%@&a=%@",first,second,newsID,[GlobalVariableStore sharedInstance].city];
    
    [shareThings retain];
    [shareBody retain];
    
    NSLog(@"++++++++++++%@",shareBody);
//    shareThings = [[pre stringByAppendingString:title] stringByAppendingString:source];
    
    [allString release];
    [webView release];
}
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
    [shareThings release];
    [shareBody release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissModalViewControllerAnimated:YES]; 
} 

-(void)sendSMS:(NSString*)body {
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if ([MFMessageComposeViewController canSendText]){
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

//创建一个AlertView
- (void) creatAlert:(NSString *)message{
    UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
    [infoAlert show];
    [self performSelector:@selector(dimissAlert:) withObject:infoAlert afterDelay:1.0];
}

- (void) dimissAlert:(UIAlertView *)alert{
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        [alert release];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) 
    { 
        case MFMailComposeResultCancelled: 
            [self creatAlert:@"邮件已舍弃!"];
            break; 
        case MFMailComposeResultSaved: 
            [self creatAlert:@"邮件已保存!"];
            break; 
        case MFMailComposeResultSent: 
            [self creatAlert:@"邮件已发送!"]; 
            break; 
        case MFMailComposeResultFailed: 
            [self creatAlert:@"邮件发送失败!"]; 
            break; 
        default: 
            break; 
    } 
    [self dismissModalViewControllerAnimated:YES];
}

-(void)sendEmail:(NSString*)body Subject:(NSString *)subject {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:subject];
    [picker setMessageBody:body isHTML:NO];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}



//列表动作
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   // NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    if(buttonIndex==0){
        
    }else if(buttonIndex==1){
        [self sendSMS:[shareThings stringByAppendingFormat:@"%@",shareBody]];
    }else if(buttonIndex==2){
        [self sendEmail:shareBody Subject:shareThings];
    }
    
}


- (void)buttonClick:(id)sender {
	
	NSLog(@"you clicked button: %@",[sender title]);
}

- (void)backButtonClick:(id)sender {	
	//NSLog(@"you clicked button back: %@",[sender title]);
    [self dismissModalViewControllerAnimated:false];    
    
}

//上一条新闻
- (void)lastButtonClick:(id)sender {
	NSMutableArray * tempMA=[LoadNews getNewsContent:newsId tabWidget:currentMainTab label:currentSubTab naviAct:@"0"] ;
    NSDictionary *item=(NSDictionary *)[tempMA objectAtIndex:0];
    NSString *title=[item objectForKey:@"article_title"];
    NSString *date=[item objectForKey:@"article_date"];
    NSString *source=[item objectForKey:@"article_from"];
    NSString *content=[item objectForKey:@"article_text"  ];
    NSString *newsID=[item objectForKey:@"id"];
    
    [self setTitleAndContent:newsID tabWidget:currentMainTab label:currentSubTab newsTitle:title date:date source:source content:content];     
}

//下一条新闻
- (void)nextButtonClick:(id)sender {
	//NSString *newsID=[item objectForKey:@"id"];
    NSMutableArray * tempMA=[LoadNews getNewsContent:newsId tabWidget:currentMainTab label:currentSubTab naviAct:@"1"] ;
    NSDictionary *item=(NSDictionary *)[tempMA objectAtIndex:0];
    NSString *title=[item objectForKey:@"article_title"];
    NSString *date=[item objectForKey:@"article_date"];
    NSString *source=[item objectForKey:@"article_from"];
    NSString *content=[item objectForKey:@"article_text"  ];
    NSString *newsID=[item objectForKey:@"id"];
    
    [self setTitleAndContent:newsID tabWidget:currentMainTab label:currentSubTab newsTitle:title date:date source:source content:content];
    
}

//收藏
- (void)favButtonClick:(id)sender {
	
	NSLog(@"you clicked button back: %@",[sender title]);
    [self dismissModalViewControllerAnimated:false];     
}


//弹出分享按钮
- (void)shareButtonClick:(id)sender {
	UIActionSheet *shareSheet;
    shareSheet=[[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博",@"分享到短信",@"分享到邮箱", nil];
    [shareSheet showInView:self.view];   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       
    //load toolbar below
    CGSize viewSize = self.view.frame.size;
	float toolbarHeight = 44.0;
	CGRect toolbarFrame = CGRectMake(0,viewSize.height-toolbarHeight,viewSize.width,toolbarHeight);
    
	UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
	
	myToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth 
    | 
    UIViewAutoresizingFlexibleLeftMargin 
    | 
    UIViewAutoresizingFlexibleRightMargin 
    | 
    UIViewAutoresizingFlexibleTopMargin;
    
    myToolbar.tintColor = RGBA(200, 0, 0, 1);
	
	UIBarButtonItem *lastNews = [[UIBarButtonItem alloc] initWithTitle:@"上一条" 
																style:UIBarButtonItemStyleBordered target:self 
															   action:@selector(lastButtonClick:)];
    UIBarButtonItem *shareButt = [[UIBarButtonItem alloc] initWithTitle:@"分享" 
																style:UIBarButtonItemStyleBordered target:self 
															   action:@selector(shareButtonClick:)];

    UIBarButtonItem *favButt = [[UIBarButtonItem alloc] initWithTitle:@"收藏" 
																style:UIBarButtonItemStyleBordered 
															   target:self 
															   action:@selector(favButtonClick:)];
    UIBarButtonItem *backButt = [[UIBarButtonItem alloc] initWithTitle:@"返回" 
																style:UIBarButtonItemStyleBordered 
															   target:self 
															   action:@selector(backButtonClick:)];
	
	UIBarButtonItem *nextNews = [[UIBarButtonItem alloc] initWithTitle:@"下一条" 
                                                                 style:UIBarButtonItemStyleBordered 
                                                                target:self 
                                                                action:@selector(nextButtonClick:)];
    /*
	UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"apple_icon.png"] 
																style:UIBarButtonItemStyleBordered 
															   target:self 
															   action:@selector(buttonClick:)];
	*/
	UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																				target:nil 
																				action:nil];
	
	UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
																				 target:self 
																				 action:@selector(buttonClick:)];
	
	NSArray *buttons = [[NSArray alloc] initWithObjects:lastNews, flexButton,shareButt,favButt,backButt, flexButton,nextNews,nil];
	
	//cleanup
	[lastNews release];
    [shareButt release];
    [favButt release];
	[nextNews release];
	[backButt release];
	[flexButton release];
	[trashButton release];
	
	[myToolbar setItems:buttons animated:NO];
    
	[buttons release];
	
	[self.view addSubview:myToolbar];
	
	[myToolbar release];	
    
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
