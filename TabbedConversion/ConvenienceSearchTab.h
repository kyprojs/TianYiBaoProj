//
//  AreaViewController.h
//  TabbedConversion
//
//  Created by lin xiaoyu on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListCustomCell.h"
#import "SDImageView+SDWebCache.h"

@interface ConvenienceSearchTab : UIViewController <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>{
    IBOutlet UITableView *selectsTable;
    
    IBOutlet UIBarButtonItem *peopleItem;
    IBOutlet UIBarButtonItem *publicItem;
    IBOutlet UIBarButtonItem *corItem;
    IBOutlet UILabel *cityLable;
    IBOutlet UILabel *nameLable;
    
    NSMutableArray *selectsList;
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    
    NSString *currentTab;
    NSString *currentSubTab;
    NSString *provinceID;
    NSString *areaCode;
    NSInteger selectedCityRow;
    
    NSMutableDictionary *tabStatus;//每个tab的状态,是否选中
    
    UIPickerView *changeCity;
    
}

@property (retain,nonatomic) IBOutlet UITableView *selectsTable;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *peopleItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *publicItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *corItem;
@property (retain,nonatomic) IBOutlet UILabel *cityLable;
@property (retain,nonatomic) IBOutlet UILabel *nameLable;

@property (retain,nonatomic) NSMutableArray *selectsList;
@property (retain,nonatomic) NSMutableArray *provinceArray;
@property (retain,nonatomic) NSMutableArray *cityArray;

@property (retain,nonatomic) NSString *currentTab;
@property (retain,nonatomic) NSString *currentSubTab;
@property (retain,nonatomic) NSString *provinceID;
@property (retain,nonatomic) NSString *areaCode;
@property (retain,nonatomic) NSMutableDictionary *tabStatus;
@property (retain,nonatomic) UIPickerView *changeCity;


- (IBAction)govPeople:(id)sender;
- (IBAction)govPublic:(id)sender;
- (IBAction)govCorp:(id)sender;
- (void)getSelected:(NSString *)mySelected;
- (IBAction)chooseProvinceAndCity:(id)sender;

@end
