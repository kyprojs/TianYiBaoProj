//
//  LoadNews.h
//  TianYiBao
//
//  Created by lin xiaoyu on 12-5-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoadNews : NSObject {
    /*
    NSString *newsClass; //新闻栏目
    NSString *newsSubClass; //新闻子栏目
    NSInteger beginIndex;//获取的新闻开始索引
    NSInteger endIndex;//
     */
}
//将json数据转化为可变数组数据
+(NSMutableArray *) parseJsonToNewsList:(NSString *)jsonString;

+(NSMutableArray *) getNewsList:(NSString *)tabWidget label:(NSString *)subClass province_id:(NSString *)prov area_code:(NSString *)city  begin_index:(NSInteger) begin end_index:(NSInteger) end; //获取新闻列表

+(NSMutableArray *) getNewsContent:(NSString*) newsID tabWidget:(NSString *)newsClass label:(NSString *)subClass naviAct:(NSString *)lastOrNext;

//获取便民查询模块的数据
+(NSMutableArray *) getSelectsList:(NSString *)tabWidget lable:(NSString *)lable province_id:(NSString *)prov area_code:(NSString *)city;

//获取财经股市新闻/公司子模块数据
+(NSMutableArray *) getFinanceNewsWithTabWidget:(NSString *)tabWidget lable:(NSString *)lable begin_index:(NSInteger)begin end_index:(NSInteger)end;

//获取财经股市数据模块
+(NSMutableArray *)getFinanceDataWithTabWidget:(NSString *)tabWidget lable:(NSString *)lable parent:(NSInteger)pId orientation:(NSString *)orient;

+(NSString *) findMyVersion:(NSString *)actype application:(NSString *)name;

//获取省份数据
+(NSMutableArray *)getProvinceAndId;

//获取城市信息
+(NSMutableArray *)getCityAndId:(NSString *)cityId;

//修改密码
+(NSString *) modifyPasswordUser:(NSString *)userName Password:(NSString *)password NewPass:(NSString *)newPass;

//用户登录
+(NSMutableDictionary *) UserLoginByName:(NSString *)userName Password:(NSString *)password;


@end
