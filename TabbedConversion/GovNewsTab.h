//
//  SummaryViewController.h
//  TabbedConversion
//
//  Created by lin xiaoyu on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListCustomCell.h"

@interface GovNewsTab : UIViewController <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate> {
    IBOutlet UISegmentedControl *newsClassChoice;
    
    IBOutlet UITableView *newsListView;
    
    IBOutlet UIBarButtonItem *govBroadCastItem;
    IBOutlet UIBarButtonItem *govInfoItem;
    IBOutlet UIBarButtonItem *localNewsItem;
    IBOutlet UIBarButtonItem *nationalNewsItem;
    
    IBOutlet UIButton *govBroadCast;
    IBOutlet UIButton *govInfo;
    IBOutlet UIButton *localNews;
    IBOutlet UIButton *nationalNews;
    
    
    
    IBOutlet UILabel *cityLable;
    IBOutlet UILabel *userLable;
    
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;    
    NSInteger selectedCityRow;
    UIPickerView *changeCity;
    

    NSMutableArray *newsList;
    
    UILabel *newsTitleLabel;
    
    NSInteger currentPage;
    NSInteger currentEndIndex;//显示到第几条，根据公司的文档，
    NSString* currentMainTab;
    NSString* currentSubTab;
    
    NSMutableDictionary * newsIndexStatus;//当前页面中的，每个TAB的显示状态。 
    
    NSString* provinceID;
    NSString* areaCode;
    
    NSString* subTabName;
    
}

@property (retain,nonatomic)  UISegmentedControl *newsClassChoice;

@property(retain,nonatomic) UIBarButtonItem *govBroadCastItem;
@property(retain,nonatomic)  UIBarButtonItem *govInfoItem;
@property(retain,nonatomic)  UIBarButtonItem *localNewsItem;
@property(retain,nonatomic)  UIBarButtonItem *nationalNewsItem;

@property (retain,nonatomic) IBOutlet UIButton *govBroadCast;
@property (retain,nonatomic) IBOutlet UIButton *govInfo;
@property (retain,nonatomic) IBOutlet UIButton *localNews;
@property (retain,nonatomic) IBOutlet UIButton *nationalNews;

@property(retain,nonatomic) UITableView *newsListView;

@property (nonatomic) NSInteger currentPage;
@property(nonatomic) NSInteger currentEndIndex;//显示到第几条，根据公司的文档，
@property(retain, nonatomic)NSString* currentSubTab;
@property(retain, nonatomic)NSString* currentMainTab;

@property(retain,nonatomic) NSString* provinceID;
@property(retain,nonatomic) NSString* areaCode;
@property(retain,nonatomic) NSMutableDictionary* newsIndexStatus;

@property (retain,nonatomic) NSMutableArray *provinceArray;
@property (retain,nonatomic) NSMutableArray *cityArray;
@property (retain,nonatomic) IBOutlet UILabel *cityLable;
@property (retain,nonatomic) IBOutlet UILabel *userLable;

@property (retain,nonatomic) UIPickerView *changeCity;


-(IBAction)showGovBroadCastNewsList:(id)sender;
-(IBAction)showGovInfoNewsList:(id)sender;
-(IBAction)showLocalNewsList:(id)sender;
-(IBAction)showNationalNewsList:(id)sender;
- (IBAction)chooseProvinceAndCity:(id)sender;

- (IBAction)govBroadStyle:(id)sender;
- (IBAction)govInfoStyle:(id)sender;
- (IBAction)localNewsStyle:(id)sender;
- (IBAction)nationStyle:(id)sender;




-(void)getNews:(NSString*)newsClass;

-(void )setupFootSpinnerView;

@end
