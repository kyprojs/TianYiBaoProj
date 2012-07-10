//
//  LoadNews.m
//  TianYiBao
//
//  Created by lin xiaoyu on 12-5-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadNews.h"
#import "SBJson.h"
#import "SBJsonParser.h"

//static NSString* dataAccessInterfaceWebSite=@"http://127.0.0.1:8080/kuyi/newslist.jsp?";
static NSString *dataAccessInterfaceWebSite=@"http://new3g.tianyibao.cn:9080/new3g/android/IarCallMS.jsp?";   

@implementation LoadNews


NSMutableArray *newsList;
/*
 tabWidget	父栏目	字符串	N	每个栏目有配置固定的值，见附录A
 label	子栏目	字符串	N	每个栏目有配置固定的值，见附录A
 province_id	省份	字符串	Y	社会民生栏目无需此参数
 area_code	地区	字符串	Y	社会民生栏目无需此参数
 begin_index	开始记录索引	字符串	N	
 end_index	终止记录索引	字符串	N	
 多行输出参数列表： 
 参数英文说明	参数中文说明	类型及长度	可空	备注
 id	文章ID	字符串	N	
 article_img	文章对应的图片	字符串	Y	 
 article_title	文章标题	字符串	N	
 article_date	文章发布日期	字符串	N	
 article_from	文章来源	字符串	Y	
 article_text	文章内容	字符串	N	截取100字以内

 */

//解析json方法
+(NSMutableArray *) parseJsonToNewsList:(NSString *)jsonString{
    SBJsonParser * parser = [[SBJsonParser alloc] init];  
    
    
    NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithDictionary:[parser objectWithString:jsonString error:nil]];
    
    
    [parser release];//parser释放---------------------------------
    
//    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc] init];
//    NSString *jsonStr=[jsonWriter stringWithObject:root];
//    [jsonWriter release];
    
    NSMutableArray *rows=[root objectForKey:@"rows"];
    
    [rows retain];
    
    return [rows autorelease];
    
    /*
    for(NSDictionary * member in rows){
        
        NSLog(@"%@", [[member objectForKey:@"article_title"] description]);
        
    }
     */
   // NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithDictionary:[parser objectWithString:jsonString error:&error]];  
    //注意转换代码  
    /*
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];  
    
    NSString *jsonString = [jsonWriter stringWithObject:root];    
    
    [jsonWriter release];  
    
    DLog(@"%@",jsonString);  
    //注意转换代码  
    NSMutableArray * customers = [root objectForKey:@"customer"];  
    DLog(@"%@",customers);  
    for(NSMutableDictionary * member  in customers)  
    {  
        DLog(@"%@",[[member objectForKey:@"name"] description]);  
    }  
    */
    
    
}

//获取版本号
+(NSString *) findMyVersion:(NSString *)actype application:(NSString *)name{
    NSString *strURL = [dataAccessInterfaceWebSite stringByAppendingFormat:@"actType=%@&application=%@",actype,name];
    
    NSString *encodeURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodeURL];
    
    [url retain];//???????
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    
    NSDictionary *some = [parser objectWithString:jsonString error:nil];
    
    NSString *version = [some objectForKey:@"versionCode"];
    
    [parser release];
    [jsonString release];//释放
    
    return version;
}

//用户登录
+(NSMutableDictionary *) UserLoginByName:(NSString *)userName Password:(NSString *)password{
    
    NSLog(@"1234");
    NSString *strURL = [dataAccessInterfaceWebSite stringByAppendingFormat:@"actType=verify&loginUsername=%@&loginPassword=%@",userName,password];
    
    NSURL *url = [NSURL URLWithString:strURL];
    [url retain];
    
    NSLog(@"%@",url);
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    
//    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[parser objectWithString:jsonString error:nil]];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithDictionary:[parser objectWithString:jsonString error:nil]];
    
    [parser release];
    [jsonString release];
    
    return data;
    
}

//修改密码
+(NSString *) modifyPasswordUser:(NSString *)userName Password:(NSString *)password NewPass:(NSString *)newPass{
    NSString *strURL = [dataAccessInterfaceWebSite stringByAppendingFormat:@"actType=updatePassword&loginUsername=%@&loginPassword=%@&newPassword=%@",userName,password,newPass];
    NSURL *url = [NSURL URLWithString:strURL];
    
    [url retain];
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *code = [parser objectWithString:jsonString error:nil];
    
    NSString *result = [code objectForKey:@"result"];
    [parser release];
    [jsonString release];
    return result;
}


//类方法,用于将新闻数据解析然后存进可变数组里面
+(NSMutableArray *) getNewsList:(NSString *)tabWidget label:(NSString *)subClass province_id:(NSString *)prov area_code:(NSString *)city begin_index:(NSInteger)begin end_index:(NSInteger)end {
    NSLog(@"getNewsList");
    
    NSString *strURL=[dataAccessInterfaceWebSite stringByAppendingFormat:@"tabWidget=%@&label=%@&province_id=%@&area_code=%@&begin_index=%u&end_index=%u",tabWidget, subClass,prov,city,begin,end ];
   
    NSString *encodeURL;
    encodeURL=[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //  encodeURL=strURL;
    //NSStringEncoding strEncode=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingHZ_GB_2312);
    
    NSLog(@"%@",encodeURL);
    
    NSURL *url=[NSURL URLWithString: encodeURL];
    
    [url retain]; //??
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    //NSLog(@"%@",jsonString); 
    //parse 
    
    NSMutableArray *newsList =[LoadNews parseJsonToNewsList:jsonString ];  // [jsonString JSONValue];
    
    
    
    if ([newsList count] >20) {
        [newsList removeLastObject];
    }

    [jsonString release];//释放内存==============================
    return newsList;    
    
    //NSLog(@"test   %@", [jsonValue description]);
    
}


//获取便民查询模块数据
+(NSMutableArray *) getSelectsList:(NSString *)tabWidget lable:(NSString *)lable province_id:(NSString *)prov area_code:(NSString *)city{
    NSLog(@"getSelects------------------");
    NSString *strURL=[dataAccessInterfaceWebSite stringByAppendingFormat:@"tabWidget=%@&label=%@&province_id=%@&area_code=%@",tabWidget, lable,prov,city];
    NSString *encodeURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"%@",encodeURL);
    NSURL *url = [NSURL URLWithString:encodeURL];
    
    [url retain];//????
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *selectsList = [LoadNews parseJsonToNewsList:jsonString];
    
    [jsonString release];//释放内存==============================
    return selectsList;
    
    
}

//获得财经股市新闻/公司子模块数据
+(NSMutableArray *) getFinanceNewsWithTabWidget:(NSString *)tabWidget lable:(NSString *)lable begin_index:(NSInteger)begin end_index:(NSInteger)end{
    
    NSString *strURL=[dataAccessInterfaceWebSite stringByAppendingFormat:@"tabWidget=%@&label=%@&begin_index=%u&end_index=%u",tabWidget, lable,begin,end];
    
    NSString *encodeURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",encodeURL);
    NSURL *url = [NSURL URLWithString:encodeURL];    
    [url retain];//????
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *FinanceNewsList = [LoadNews parseJsonToNewsList:jsonString];
    if ([FinanceNewsList count] >20) {
        [FinanceNewsList removeLastObject];
    }
    
    [jsonString release];//释放内存==============================
    return FinanceNewsList;
    
}

//获取财经市场数据模块
+(NSMutableArray *)getFinanceDataWithTabWidget:(NSString *)tabWidget lable:(NSString *)lable parent:(NSInteger)pId orientation:(NSString *)orient{
    NSString *strURL = [dataAccessInterfaceWebSite stringByAppendingFormat:@"tabWidget=%@&label=%@&parent_id=%d&orientation=%@",tabWidget,lable,pId,orient];
    
    NSLog(@"%@",strURL);
    
    NSURL *url = [NSURL URLWithString:strURL];
    [url retain];//???
    
    NSString *jsonString = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *financeData = [LoadNews parseJsonToNewsList:jsonString];
    
    [jsonString release];
    return financeData;
    
}

//获取省份数据
+(NSMutableArray *)getProvinceAndId{
    NSString *strURL = [dataAccessInterfaceWebSite stringByAppendingFormat:@"actType=province"];
    NSLog(@"%@",strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    [url retain];//???
    NSString *jsonString = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *provinceArray = [LoadNews parseJsonToNewsList:jsonString];
    
    [jsonString release];
    return provinceArray;
    
}

//获取省份对应的城市数据
+(NSMutableArray *)getCityAndId:(NSString *)cityId{
    NSString *strURL = [dataAccessInterfaceWebSite stringByAppendingFormat:@"actType=city&province_id=%@",cityId];
    NSLog(@"%@",strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    [url retain];
    
    NSString *jsonString = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *cityArray = [LoadNews parseJsonToNewsList:jsonString];
    [jsonString release];
    return cityArray;    
}


//获得新闻的内容
+(NSMutableArray *) getNewsContent:(NSString*) newsID tabWidget:(NSString *)newsClass label:(NSString *)subClass  naviAct:(NSString *)lastOrNext {
    NSString * strURL;    
    if (lastOrNext==nil) {
        strURL=[dataAccessInterfaceWebSite stringByAppendingFormat:@"id=%@&tabWidget=%@&label=%@",newsID,newsClass, subClass ];
    }else{
          strURL=[dataAccessInterfaceWebSite stringByAppendingFormat:@"id=%@&tabWidget=%@&label=%@&navigation_act=%@",newsID,newsClass, subClass,lastOrNext ];
    }
   
    
    NSString *encodeURL;
    encodeURL=[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //  encodeURL=strURL;
    //NSStringEncoding strEncode=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingHZ_GB_2312);
    
    NSLog(@"%@",encodeURL);
    
    NSURL *url=[NSURL URLWithString: encodeURL];
    
    [url retain]; //??
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url   encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"getNewsContent %@",jsonString); 
    //parse 
    
    NSMutableArray *newsDetail =[LoadNews parseJsonToNewsList:jsonString ];  // [jsonString JSONValue];
   
    [jsonString release];//释放内存==============================
    return newsDetail;
        //NSLog(@"test   %@", [jsonValue description]);
    
}




/*
+(NSMutableArray *) getNewsList:(NSString *)newsClass newsSubclass:(NSString *)subClass newsBeginIndex:(NSInteger) beginIndex newsEndIndex:(NSInteger) endIndex{ //获取新闻列表
    
    newsList= [[NSMutableArray alloc] initWithObjects:
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 1 中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"2012-5-22",@"publishDate",
                @"中国新闻网",@"newsSource",
                @"5月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 1 中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"2012-5-22",@"publishDate",
                @"中国新闻网",@"newsSource",
                @"5月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 1 中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"2012-5-22",@"publishDate",
                @"2中国新闻网",@"newsSource",
                @"25月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 1 中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 1 中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 1 3中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 2 3中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 2 3中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 2 3中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 2 3中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 2 3中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               [[NSDictionary alloc] initWithObjectsAndKeys:
                @"page 2 3中央军委副主席郭伯雄因工作原因取消访日",@"mainTitleKey",
                @"32012-5-22",@"publishDate",
                @"3中国新闻网",@"newsSource",
                @"35月22日，国防部新闻事务局向中国日报证实，中央军委副主席郭伯雄由于工作安排的原因，访日之行难以成行",@"secondaryTitleKey",nil],
               nil];
    
    NSMutableArray *tempArr= [[NSMutableArray alloc] init];
    for (int i=beginIndex; i<=endIndex; i++) {
        [tempArr addObject:[newsList objectAtIndex:i]];
    }
    
    return tempArr ;
    
    
}
*/



@end
