//
//  FinanceNewsTab.h
//  TianYiBao
//
//  Created by lin xiaoyu on 12-5-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListCustomCell.h"


@interface FinanceNewsTab : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *FinanceListView;
    
    IBOutlet UIBarButtonItem *newsItem;
    IBOutlet UIBarButtonItem *corpItem;
    IBOutlet UIBarButtonItem *dataItem;
    IBOutlet UIBarButtonItem *fofItem;
    IBOutlet UIBarButtonItem *debeItem;
    
    NSMutableArray *FinanceList;//数据
    
    NSString* currentMainTab;
    NSString* currentSubTab;
    
    NSMutableDictionary *subTabStatus;//当前页面中的，每个TAB的显示状态。 
}

@property (retain,nonatomic) IBOutlet UITableView *FinanceListView;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *newsItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *corpItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *dataItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *fofItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *debeItem;

@property (retain,nonatomic) NSMutableArray *FinanceList;
@property (retain,nonatomic) NSString *currentMainTab;
@property (retain,nonatomic) NSString *currentSubTab;
@property (retain,nonatomic) NSMutableDictionary *subTabStatus;

- (IBAction)getNewsClick:(id)sender;
- (IBAction)getCorClick:(id)sender;
- (IBAction)getDataClick:(id)sender;
- (IBAction)getFofClick:(id)sender;
- (IBAction)getDebeClick:(id)sender;



@end
