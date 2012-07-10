//
//  VolumeViewController.m
//  TabbedConversion
//
//  Created by lin xiaoyu on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SocietyNewsTab.h"
#import "GlobalVariableStore.h" 
#import "LoadNews.h"
#import "NewsDetailViewController.h"

#define PAGE_SIZES 20
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@implementation SocietyNewsTab

@synthesize societyListView,attenItem,straitsItem,itItem,teachItem,sportItem,healthItem;
@synthesize currentMainTab,currentSubTab;
@synthesize tabStatus;
@synthesize societyList;
@synthesize provinceID,areaCode;

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
    [societyListView release];
    [attenItem release];
    [straitsItem release];
    [itItem release];
    [teachItem release];
    [sportItem release];
    [healthItem release];
    
    [societyList release];
    
    [currentMainTab release];
    [currentSubTab release];
    [tabStatus release];
    
    [provinceID release];
    [areaCode release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//点击查看更多执行的事件
-(void) loadMore{
//    NSMutableArray *more = [[NSMutableArray alloc] initWithCapacity:0];
    
//    NSString *curIndex = [[NSString alloc]init];
//    curIndex = [tabStatus objectForKey:currentSubTab];
    
    //无需手动释放
    NSString *curIndex = [NSString stringWithString:[tabStatus objectForKey:currentSubTab]];
    
    int page = [curIndex intValue];
    NSMutableArray *more = [LoadNews getNewsList:TAB_LIVE label:currentSubTab province_id:provinceID area_code:areaCode begin_index:page*20+1 end_index:(page+1)*20+1];
    [tabStatus setValue:[NSString stringWithFormat:@"%d",page+1] forKey:currentSubTab];
    [self performSelectorOnMainThread:@selector(appendListWith:) withObject:more waitUntilDone:NO];
//    [more release];
}

-(void) appendListWith:(NSMutableArray *)newData{
    [societyList addObjectsFromArray:newData];
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:PAGE_SIZES];
    for (int ind = 0; ind<6; ind++) {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[societyList indexOfObject:[newData objectAtIndex:ind]] inSection:0]; 
        [insertIndexPaths addObject:newPath];
    }
    [self.societyListView reloadData];
}



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [societyList count]+1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=nil;
    NSString *ViewCellIdentifier=@"cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    
    if (cell == nil)
        cell = [[[NewsListCustomCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:ViewCellIdentifier] autorelease];
    UIView *cellView;
    
    if ([indexPath row] == [societyList count]) {
        
        cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        
        UIButton *moreButton;
        moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cellView addSubview:moreButton];
        [moreButton setFrame:CGRectMake(60, 15, 200, 30)];
        [moreButton setBackgroundColor:[UIColor whiteColor]];
        [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [moreButton setTitle:@"...点击查看更多..." forState:UIControlStateNormal];
        
        //将显示更多的按钮关联到其响应时间上
        [moreButton addTarget:self action:@selector(moreLiveNewsClick) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        ((NewsListCustomCell *)cell).view = cellView;
        
        [cellView release];
        
        return cell;
        
    } else {
        cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
        
        NSDictionary *item = (NSDictionary *)[societyList objectAtIndex:indexPath.row];
        
        //每一条的图标
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"imageKey" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        UIImageView *newsIconView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 6, 44, 44)];
        newsIconView.image = image;
        [cellView addSubview:newsIconView];
        [newsIconView release];//内存释放
        
        //标题
        UILabel *newsTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(52, 4, 270, 15)];
        newsTitleLable.textColor = RGBA(67, 110, 238, 1);
        newsTitleLable.text = [item objectForKey:@"article_title"];
        [cellView addSubview:newsTitleLable];
        [newsTitleLable release];
        
        //日期
        UILabel *newsDate = [[UILabel alloc]initWithFrame:CGRectMake(52, 22, 100, 15)];
        newsDate.textColor = RGBA(178, 34, 34, 1);
        newsDate.text = [item objectForKey:@"article_date"];
        [cellView addSubview:newsDate];
        [newsDate release];
        
        //来源
        UILabel *newsSource = [[UILabel alloc] initWithFrame:CGRectMake(150, 22, 150, 15)];
        newsSource.textColor = RGBA(205, 201, 201, 1);
        newsSource.text = [item objectForKey:@"article_from"];
        [cellView addSubview:newsSource];
        [newsSource release];
        
        //内容
        UILabel *newsContent = [[UILabel alloc]initWithFrame:CGRectMake(52, 40, 270, 15)];
        newsContent.textColor = [UIColor blackColor];
        [newsContent setText:[item objectForKey:@"article_text"]];
        [cellView addSubview:newsContent];
        [newsContent release];
        
        ((NewsListCustomCell *)cell).view = cellView;
        
        [cellView release];
        
        return cell;

    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ([societyList count])) { 
        
    }else{
        NewsDetailViewController *nextController = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
        NSDictionary *item = (NSDictionary *)[societyList objectAtIndex:indexPath.row];
        NSString *title=[item objectForKey:@"article_title"];
        NSString *date=[item objectForKey:@"article_date"];
        NSString *source=[item objectForKey:@"article_from"];
        NSString *newsID=[item objectForKey:@"id"];
        NSMutableArray * tempMA=[LoadNews getNewsContent:newsID tabWidget:currentMainTab label:currentSubTab naviAct:nil] ;
        NSDictionary *tempDic=(NSDictionary *)[tempMA objectAtIndex:0];
        NSString *content=[tempDic objectForKey:@"article_text"  ];
        
        [nextController setTitleAndContent:newsID tabWidget:currentMainTab label:currentSubTab newsTitle:title date:date
                                    source:source content:content];
        [[self parentViewController] presentModalViewController:nextController animated:false];
        [nextController release];
    }
}



#pragma mark - View lifecycle

-(void)initTheData{
    currentMainTab = TAB_LIVE;
    currentSubTab = TAB_LIVE_ATTEN;
    provinceID = [GlobalVariableStore sharedInstance].provinceId;//取得静态变量
    areaCode = [GlobalVariableStore sharedInstance].city;
    
    //设置键数组
    NSArray *keys = [NSArray arrayWithObjects:TAB_LIVE_ATTEN,TAB_LIVE_STRAITS,TAB_LIVE_IT,TAB_LIVE_TEACH,TAB_LIVE_SPORT,TAB_LIVE_HEALTH,nil];
    //设置值数组
    NSArray *objects = [NSArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",nil];
    tabStatus = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    //注意以上这三个方法的调用,Objects是有s结尾的
    
    [tabStatus retain];
    
    societyList = [LoadNews getNewsList:TAB_LIVE label:TAB_LIVE_ATTEN province_id:provinceID area_code:areaCode begin_index:1 end_index:21];
    [attenItem setStyle:UIBarButtonItemStyleDone];
    [straitsItem setStyle:UIBarButtonItemStyleBordered];
    [itItem setStyle:UIBarButtonItemStyleBordered];
    [teachItem setStyle:UIBarButtonItemStyleBordered];
    [sportItem setStyle:UIBarButtonItemStyleBordered];
    [healthItem setStyle:UIBarButtonItemStyleBordered];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [self initTheData];
//}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initTheData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//选项卡选项得到数据
-(IBAction)getLiveNews:(NSString*)subTab {
    //NSString *newsClass;
    
    currentSubTab=subTab ;
    
    NSString* currIndex=[tabStatus objectForKey:currentSubTab];
    NSLog(@"getnews:  %@", currIndex);
    
    int page=[currIndex intValue];  
    societyList=[LoadNews getNewsList:TAB_LIVE label:currentSubTab province_id:provinceID area_code:areaCode begin_index:(page-1)*20+1 end_index:(page)*20+1];
    
    [societyListView reloadData];
}

//各个Item的点击事件
-(void)moreLiveNewsClick{
    [self loadMore];
}

- (IBAction)getLiveAttent:(id)sender {
    [attenItem setStyle:UIBarButtonItemStyleDone];
    [straitsItem setStyle:UIBarButtonItemStyleBordered];
    [itItem setStyle:UIBarButtonItemStyleBordered];
    [teachItem setStyle:UIBarButtonItemStyleBordered];
    [sportItem setStyle:UIBarButtonItemStyleBordered];
    [healthItem setStyle:UIBarButtonItemStyleBordered];
    [self getLiveNews:TAB_LIVE_ATTEN];
}

- (IBAction)getLiveStraits:(id)sender {
    [attenItem setStyle:UIBarButtonItemStyleBordered];
    [straitsItem setStyle:UIBarButtonItemStyleDone];
    [itItem setStyle:UIBarButtonItemStyleBordered];
    [teachItem setStyle:UIBarButtonItemStyleBordered];
    [sportItem setStyle:UIBarButtonItemStyleBordered];
    [healthItem setStyle:UIBarButtonItemStyleBordered];
    [self getLiveNews:TAB_LIVE_STRAITS];
}

- (IBAction)getLiveIt:(id)sender {
    [attenItem setStyle:UIBarButtonItemStyleBordered];
    [straitsItem setStyle:UIBarButtonItemStyleBordered];
    [itItem setStyle:UIBarButtonItemStyleDone];
    [teachItem setStyle:UIBarButtonItemStyleBordered];
    [sportItem setStyle:UIBarButtonItemStyleBordered];
    [healthItem setStyle:UIBarButtonItemStyleBordered];
    [self getLiveNews:TAB_LIVE_IT];
}

- (IBAction)getLiveTeach:(id)sender {
    [attenItem setStyle:UIBarButtonItemStyleBordered];
    [straitsItem setStyle:UIBarButtonItemStyleBordered];
    [itItem setStyle:UIBarButtonItemStyleBordered];
    [teachItem setStyle:UIBarButtonItemStyleDone];
    [sportItem setStyle:UIBarButtonItemStyleBordered];
    [healthItem setStyle:UIBarButtonItemStyleBordered];
    [self getLiveNews:TAB_LIVE_TEACH];
}

- (IBAction)getLiveSport:(id)sender {
    [attenItem setStyle:UIBarButtonItemStyleBordered];
    [straitsItem setStyle:UIBarButtonItemStyleBordered];
    [itItem setStyle:UIBarButtonItemStyleBordered];
    [teachItem setStyle:UIBarButtonItemStyleBordered];
    [sportItem setStyle:UIBarButtonItemStyleDone];
    [healthItem setStyle:UIBarButtonItemStyleBordered];
    [self getLiveNews:TAB_LIVE_SPORT];
}

- (IBAction)getLiveHealth:(id)sender {
    [attenItem setStyle:UIBarButtonItemStyleBordered];
    [straitsItem setStyle:UIBarButtonItemStyleBordered];
    [itItem setStyle:UIBarButtonItemStyleBordered];
    [teachItem setStyle:UIBarButtonItemStyleBordered];
    [sportItem setStyle:UIBarButtonItemStyleBordered];
    [healthItem setStyle:UIBarButtonItemStyleDone];
    [self getLiveNews:TAB_LIVE_HEALTH];
}

@end
