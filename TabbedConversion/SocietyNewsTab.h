//
//  VolumeViewController.h
//  TabbedConversion
//
//  Created by lin xiaoyu on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListCustomCell.h"


@interface SocietyNewsTab : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *societyListView;
    
    IBOutlet UIBarButtonItem *attenItem;//关注
    IBOutlet UIBarButtonItem *straitsItem;//海峡
    IBOutlet UIBarButtonItem *itItem;//IT
    IBOutlet UIBarButtonItem *teachItem;//教育
    IBOutlet UIBarButtonItem *sportItem;//体育
    IBOutlet UIBarButtonItem *healthItem;//健康
    
    NSMutableArray *societyList;//新闻列表
    
    NSString *currentMainTab;
    NSString *currentSubTab;
    
    NSMutableDictionary *tabStatus;
    
    NSString *provinceID;
    NSString *areaCode;
    
}

@property (retain,nonatomic) IBOutlet UITableView *societyListView;

@property (retain,nonatomic) IBOutlet UIBarButtonItem *attenItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *straitsItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *itItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *teachItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *sportItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *healthItem;

@property(retain, nonatomic)NSString* currentSubTab;
@property(retain, nonatomic)NSString* currentMainTab;

@property (retain,nonatomic) NSMutableArray *societyList;
@property(retain,nonatomic) NSString* provinceID;
@property(retain,nonatomic) NSString* areaCode;
@property(retain,nonatomic) NSMutableDictionary* tabStatus;

- (IBAction)getLiveAttent:(id)sender;
- (IBAction)getLiveStraits:(id)sender;
- (IBAction)getLiveIt:(id)sender;
- (IBAction)getLiveTeach:(id)sender;
- (IBAction)getLiveSport:(id)sender;
- (IBAction)getLiveHealth:(id)sender;



@end
