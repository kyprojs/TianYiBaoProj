//
//  GlobalVariableStore.h
//  TianYiBao
//
//  Created by lin xiaoyu on 12-6-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//政务资讯模块
#define TAB_GOV                @"tab_government"
#define TAB_GOV_NOTI         @"tab_government_notice"  //政府通告
#define TAB_GOV_MESS         @"tab_government_mess" //政府信息
#define TAB_LOCAL_NEWS        @"tab_government_news"  //本地新闻
#define TAB_NATIONAL_BRIE     @"tab_government_major" //4 全国要闻

//便民查询模块
#define TAB_SELECTS @"tab_selects"
#define TAB_GOV_PEO @"tab_government_people"    //便民查询
#define TAB_GOV_PUB @"tab_government_public"    //公众查询
#define TAB_GOV_COR @"tab_government_corporation"   //企业查询

//社会民生模块模块
#define TAB_LIVE @"tab_livelihood"
#define TAB_LIVE_ATTEN @"tab_livelihood_atten"
#define TAB_LIVE_STRAITS @"tab_livelihood_straits"
#define TAB_LIVE_IT @"tab_livelihood_it"
#define TAB_LIVE_TEACH @"tab_livelihood_teach"
#define TAB_LIVE_SPORT @"tab_livelihood_sport"
#define TAB_LIVE_HEALTH @"tab_livelihood_health"

//财经股市模块
#define TAB_FINANCE @"tab_finance"
#define TAB_FINANCE_NEWS @"tab_finance_news"
#define TAB_FINANCE_CORP @"tab_finance_corpor"
#define TAB_FINANCE_DATA @"tab_finance_data"
#define TAB_FINANCE_FOF @"tab_finance_fof"
#define TAB_FINANCE_DEBE @"tab_finance_debenture"

//应用下载模块
#define TAB_APP @"tab_appdown"
#define TAB_APP_HOT @"tab_appdown_app"
#define TAB_APP_NEW @"tab_appdown_newest"
#define TAB_APP_RANK @"tab_appdown_sort"
#define TAB_APP_ADVICE @"tab_appdown_recommend"

//团购市场模块
#define TAB_GROUP @"tab_grouppurchase"
#define TAB_GROUP_HOT @"tab_grouppurchase_yi"
#define TAB_GROUP_MARKET @"tab_grouppurchase_books"


@interface GlobalVariableStore : NSObject {
    NSString* provinceId;   //所在省份
    NSString* city;//所在城市
    NSString *cityName;
    NSString *nickName;
    
}
@property(retain,nonatomic)  NSString* provinceId;   //所在省份
@property(retain,nonatomic)  NSString* city;//所在城市
@property(retain,nonatomic) NSString *cityName;
@property(retain,nonatomic) NSString *nickName;

+(GlobalVariableStore *) sharedInstance;

@end
