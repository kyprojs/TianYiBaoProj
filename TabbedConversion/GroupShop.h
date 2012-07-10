//
//  GroupShop.h
//  TianYiBao
//
//  Created by pauling on 12-6-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListCustomCell.h"
#import "SDImageView+SDWebCache.h"

@interface GroupShop : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *bookListView;
    IBOutlet UIBarButtonItem *hotShopItem;
    IBOutlet UIBarButtonItem *bookMarketItem;
    
    NSMutableArray *bookList;
    NSString *currentMainTab;
    NSString *currentSubTab;
    
    NSMutableDictionary *subTabStatus;
    
}

@property (retain,nonatomic) IBOutlet UITableView *bookListView;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *hotShopItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *bookMarketItem;
@property (retain,nonatomic) NSMutableArray *bookList;
@property (retain,nonatomic) NSString *currentMainTab;
@property (retain,nonatomic) NSString *currentSubTab;
@property (retain,nonatomic) NSMutableDictionary *subTabStatus;

- (IBAction)getHotBuy:(id)sender;
- (IBAction)getBookMaketList:(id)sender;

@end
