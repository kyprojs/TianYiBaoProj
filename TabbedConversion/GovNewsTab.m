//
//  SummaryViewController.m
//  TabbedConversion
//
//  Created by lin xiaoyu on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GovNewsTab.h"
#import "NewsDetailViewController.h"
#import "LoadNews.h"
#import "GlobalVariableStore.h"


#define PAGE_SIZES 20
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation GovNewsTab

@synthesize newsClassChoice;
@synthesize currentEndIndex,currentMainTab, currentSubTab, currentPage;
@synthesize govBroadCastItem,govInfoItem,localNewsItem,nationalNewsItem,changeCity,cityLable,userLable,provinceArray,cityArray;
@synthesize newsListView;
@synthesize provinceID,areaCode;
@synthesize newsIndexStatus;//记录当前TAB中的记录状态

@synthesize govBroadCast,govInfo,localNews,nationalNews;



//加载更多新闻
-(void)loadMore 
{ 
//    NSMutableArray *more=[[NSMutableArray alloc] initWithCapacity:0]; 
    
//    NSString* currIndex=[[NSString alloc ]init];
//    currIndex=[newsIndexStatus objectForKey:currentSubTab];
    
    //无需手动释放
    NSString *curIndex = [NSString stringWithString:[newsIndexStatus objectForKey:currentSubTab]];
    
    int page=[curIndex intValue];
    NSMutableArray *more=[LoadNews getNewsList:TAB_GOV label:currentSubTab province_id:provinceID area_code:areaCode begin_index:page*20+1 end_index:(page+1)*20+1];
    [newsIndexStatus setValue:[NSString stringWithFormat:@"%d",page+1] forKey:currentSubTab];
    
    //加载你的数据 
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO]; 
//    [more release]; 
} 


//将加载更多的数据填充进tableView中的数组
-(void) appendTableWith:(NSMutableArray *)data 
{ 
    //NSLog(@"%u",[data count]);
    for (int i=0;i<[data count];i++) { 
        [newsList addObject:[data objectAtIndex:i]]; 
    } 
   // [newsListView reloadData];
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:PAGE_SIZES]; 
    for (int ind = 0; ind < 6; ind++) { 
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[newsList indexOfObject:[data objectAtIndex:ind]] inSection:0]; 
        [insertIndexPaths addObject:newPath]; 
    } 
    [self.newsListView reloadData];//重新刷新tableView
    //[self.newsListView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight]; 
    
} 



//点击查看更多执行的事件
-(void)moreNewsButtonclick{
   // [self performSelectorInBackground:@selector(loadMore) withObject:nil]; 
    [self loadMore];
}




//添加选择器按钮
-(UIView*)createPickerContainer {
    UIView *view = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIView *transview = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 40)];
    [transview setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor blueColor]];
    [leftButton setFrame:CGRectMake(20, 5, 60, 30)]; 
    [leftButton setTitle:@"取消" forState:UIControlStateNormal]; 
    [leftButton addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpInside]; 
    [transview addSubview:leftButton]; 
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor blueColor]];
    [rightButton setFrame:CGRectMake(240, 5, 60, 30)]; 
    [rightButton setTitle:@"设置" forState:UIControlStateNormal]; 
    [rightButton addTarget:self action:@selector(buttonOK:) forControlEvents:UIControlEventTouchUpInside]; 
    [transview addSubview:rightButton]; 
    [view addSubview:transview];
    
    [transview release];
    
    return view;
}

-(void)showPickers{
    UIView *view = [self createPickerContainer];
    UIPickerView *pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
    self.changeCity = pickerview;
    pickerview.delegate = self;
    pickerview.dataSource = self;
    pickerview.showsSelectionIndicator = YES;
    
    self.cityArray = [LoadNews getCityAndId:provinceID];//初始化所选的省份
    
    [pickerview selectRow:[provinceID intValue]-1 inComponent:0 animated:NO];
    [pickerview selectRow:selectedCityRow inComponent:1 animated:NO];
    
    [view addSubview:pickerview];
    
    [pickerview release];
    
    [self.view addSubview:view];
}

//返回几个选取器
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//每个选取器有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) 
        return 34;
    if (component == 1) 
        return [cityArray count];
    assert(0);
    return 0;
}

//每行选取器显示内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[provinceArray objectAtIndex:row] objectForKey:@"province_name"];
    } else if (component == 1) {
        return [[cityArray objectAtIndex:row] objectForKey:@"city_name"];
    } 
    assert(0);
    return @"";
}

//城市选取器依赖于省份选取器
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSString *selectProvinceId = [[provinceArray objectAtIndex:row] objectForKey:@"province_id"];
        self.cityArray = [LoadNews getCityAndId:selectProvinceId];
        [self.changeCity selectRow:0 inComponent:1 animated:YES];
        [self.changeCity reloadComponent:1];
    }
}

//取消按钮
- (void)buttonCancel:(id)sender {
    [[[sender superview] superview] removeFromSuperview];
    self.changeCity = nil;
}


//确定按钮改变城市
- (void)buttonOK:(id)sender {
    if (self.changeCity) {
        NSString *getMyProvinceId = [[provinceArray objectAtIndex:[self.changeCity selectedRowInComponent:0]] objectForKey:@"province_id"];
        
        selectedCityRow = [self.changeCity selectedRowInComponent:1];
        
        NSString *getMyCityId = [[cityArray objectAtIndex:selectedCityRow] objectForKey:@"city_id"];
        
        cityLable.text = [[cityArray objectAtIndex:selectedCityRow] objectForKey:@"city_name"];
        
        
        [GlobalVariableStore sharedInstance].provinceId=getMyProvinceId;
        [GlobalVariableStore sharedInstance].city=getMyCityId;
        [GlobalVariableStore sharedInstance].cityName = cityLable.text;
        
        provinceID = getMyProvinceId;
        areaCode = getMyCityId;
        newsList = [LoadNews getSelectsList:TAB_GOV lable:currentSubTab province_id:provinceID area_code:areaCode];
        
        [self.newsListView reloadData];
        
        [[[sender superview] superview] removeFromSuperview];
        
        self.changeCity = nil;
    }
}

- (IBAction)chooseProvinceAndCity:(id)sender {
    [self showPickers];
}


-(void)changeButtonStyleToSelect:(UIButton *)button {
    [button setBackgroundImage:[UIImage imageNamed:@"play_background.png"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)changeButtonStyleToUnselect:(UIButton *)button{
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (IBAction)govBroadStyle:(id)sender {
    [self changeButtonStyleToSelect:govBroadCast];
    [self changeButtonStyleToUnselect:govInfo];
    [self changeButtonStyleToUnselect:localNews];
    [self changeButtonStyleToUnselect:nationalNews];
}

- (IBAction)govInfoStyle:(id)sender {
    [self changeButtonStyleToUnselect:govBroadCast];
    [self changeButtonStyleToSelect:govInfo];
    [self changeButtonStyleToUnselect:localNews];
    [self changeButtonStyleToUnselect:nationalNews];
    //try to commit and push
}

- (IBAction)localNewsStyle:(id)sender {
    [self changeButtonStyleToUnselect:govBroadCast];
    [self changeButtonStyleToUnselect:govInfo];
    [self changeButtonStyleToSelect:localNews];
    [self changeButtonStyleToUnselect:nationalNews];
}

- (IBAction)nationStyle:(id)sender {
    [self changeButtonStyleToUnselect:govBroadCast];
    [self changeButtonStyleToUnselect:govInfo];
    [self changeButtonStyleToUnselect:localNews];
    [self changeButtonStyleToSelect:nationalNews];
}






-(void )setupFootSpinnerView{
    
    /*
    UIActivityIndicatorView *activeIndi= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    NSInteger width=30;
    CGRect activeFrame=CGRectMake(160-width/2, 5, width, width);
    [activeIndi setFrame:activeFrame];
    [activeIndi startAnimating];
    
    UIView *footSpinnerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, width)];
    [footSpinnerView addSubview:activeIndi];
    
    self.newsListView.tableFooterView= footSpinnerView;
    */
     
}


//设置more按钮的样式
-(void)setMoreButt{
    
    UIButton *moreButton=[UIButton buttonWithType:UIBarStyleDefault];
    
    [moreButton setTitle:@"...点击显示更多..."   forState:  UIControlStateNormal ];
    
    [moreButton addTarget:self action:@selector(moreNewsButtonclick) forControlEvents:UIControlEventTouchUpInside];
   
}




-(void )setupHeaderSpinnerView{
    
    
    UIActivityIndicatorView *activeIndi= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    NSInteger width=30;
   // NSInteger t=self.newsListView.bounds.size.height;
    CGRect activeFrame=CGRectMake(160-width/2, -10, width, width);

    [activeIndi setFrame:activeFrame];
    [activeIndi startAnimating];
    
    UIView *headerSpinnerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, width)];
    [headerSpinnerView addSubview:activeIndi];
    
    self.newsListView.tableHeaderView= headerSpinnerView;
    //[self.newsListView.tableFooterView addSubview: footSpinnerView];
    
    //[footSpinnerView release];
    
}

/*

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //setupBootSpinnerView  
    if (indexPath.row == NEWS_NUMBER_OF_ONEPAGE-1) {
        NSLog(@"[self setupFootSpinnerView]"); 
        
        [self setupFootSpinnerView];
        [self getNews:1 page:2];
       
        //[self.newsListView reloadData];
    }else {
        NSLog(@"[ self.newsListView.tableFooterView = nil;"); 
        self.newsListView.tableFooterView = nil;
    }
    
   
    
}
*/

//segment code of show News()
-(IBAction)showGovBroadCastNewsList:(id)sender{
    [govBroadCastItem setStyle:UIBarButtonItemStyleDone];    
    [govInfoItem setStyle:UIBarButtonItemStyleBordered];
    [localNewsItem setStyle:UIBarButtonItemStyleBordered];
    [nationalNewsItem setStyle:UIBarButtonItemStyleBordered];
    [self getNews: @"tab_government_notice"  ];
}
-(IBAction)showGovInfoNewsList:(id)sender{
    [govBroadCastItem setStyle:UIBarButtonItemStyleBordered];
    [govInfoItem setStyle:UIBarButtonItemStyleDone];
    [localNewsItem setStyle:UIBarButtonItemStyleBordered];
    [nationalNewsItem setStyle:UIBarButtonItemStyleBordered];
    [self getNews:TAB_GOV_MESS];
  //  [self.newsListView reloadData];
}
-(IBAction)showLocalNewsList:(id)sender{
    [govBroadCastItem setStyle:UIBarButtonItemStyleBordered];
    [govInfoItem setStyle:UIBarButtonItemStyleBordered];
    [localNewsItem setStyle:UIBarButtonItemStyleDone];
    [nationalNewsItem setStyle:UIBarButtonItemStyleBordered];
    [self getNews:TAB_LOCAL_NEWS];
    //[self.newsListView reloadData];
}
-(IBAction)showNationalNewsList:(id)sender{
    [govBroadCastItem setStyle:UIBarButtonItemStyleBordered];
    [govInfoItem setStyle:UIBarButtonItemStyleBordered];
    [localNewsItem setStyle:UIBarButtonItemStyleBordered];
    [nationalNewsItem setStyle:UIBarButtonItemStyleDone];
    [self getNews:TAB_NATIONAL_BRIE];
   // [self.newsListView reloadData];
}



//-(UIButton *)changeButtonStyle:(NSString *)title{
//    UIButton *button = [[UIButton alloc]init];
////    [button setBackgroundColor:[UIColor whiteColor]];
//    [button setFrame:CGRectMake(0, 0, 70, 31)];
//    [button setBackgroundImage:[UIImage imageNamed:@"play_background.png"] forState:UIControlStateSelected];
//    [button setTitle:title forState:UIControlStateSelected];
//    [button retain];
//    return button;
//}



//设置每一行表的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     //The code following utiliting stand cell 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *item = (NSDictionary *)[newsList objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    cell.detailTextLabel.text = [item objectForKey:@"secondaryTitleKey"];
    NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    return cell;
    */
    
    UITableViewCell *cell=nil;
    NSString *ViewCellIdentifier=@"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    if (cell == nil)
        cell = [[[NewsListCustomCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:ViewCellIdentifier] autorelease];
    UIView *cellView;
    
    
    //判断是否要显示查看更多的一行
    if([indexPath row] == ([newsList count])) { 
               
        cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        
        UIButton *moreButton;
        //=[[UIButton alloc]initWithFrame:CGRectMake(100, 5, 200, 30)];
        
        moreButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];        
        [moreButton setFrame:CGRectMake(60, 15, 200, 30)];
        [moreButton setBackgroundColor:[UIColor whiteColor]];
        [moreButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal ];
        [moreButton setTitle:@"...点击显示更多..."   forState:  UIControlStateNormal ];
        
        [moreButton addTarget:self action:@selector(moreNewsButtonclick) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:moreButton];
        
        //[cellView setExclusiveTouch:true];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
               
         ((NewsListCustomCell *)cell).view = cellView;
        
        [cellView release];
        
        return  cell;
    }else{
        //填充每一行的数据
           
        cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
        //NSLog(@"%u", indexPath.row);
        NSDictionary *item = (NSDictionary *)[newsList objectAtIndex:indexPath.row];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"imageKey" ofType:@"png"];
        UIImage *theImage = [UIImage imageWithContentsOfFile:path];    
        UIImageView *newsIcon=  [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 44, 44)];
        newsIcon.image=theImage;
        [cellView addSubview:newsIcon];
        [newsIcon release];
        
        UILabel *newsTitleInCell= [[UILabel alloc] initWithFrame:CGRectMake(52, 4, 270, 15)];
        //[newsTitleInCell setText:@"news title news title news title news title news title"];
        newsTitleInCell.textColor=RGBA(67 ,110, 238 , 1); 
        newsTitleInCell.text = [item objectForKey:@"article_title"];
        [cellView addSubview:newsTitleInCell];
        [newsTitleInCell release];
        
        UILabel *newsDateInCell= [[UILabel alloc] initWithFrame:CGRectMake(52, 22, 100, 15)];
        newsDateInCell.textColor=RGBA(178, 34, 34, 1);// 
        newsDateInCell.text=[item objectForKey:@"article_date"];
        [cellView addSubview:newsDateInCell];
        [newsDateInCell release];
        
        UILabel *newsSourceInCell= [[UILabel alloc] initWithFrame:CGRectMake(150, 22, 150, 15)];
        newsSourceInCell.text=[item objectForKey:@"article_from"];
        newsSourceInCell.textColor=RGBA(205, 201, 201, 1);// 
        [cellView addSubview:newsSourceInCell];
        [newsSourceInCell release];
        
        UILabel *newsContAbsInCell= [[UILabel alloc] initWithFrame:CGRectMake(52, 40, 270, 15)];
        newsContAbsInCell.textColor=[UIColor blackColor];
        [newsContAbsInCell setText:[item objectForKey:@"article_text"  ]];
        [cellView addSubview:newsContAbsInCell];
        [newsContAbsInCell release];
        
        ((NewsListCustomCell *)cell).view = cellView;
        
        [cellView release];
        return cell;
    }
    
     
   
}



//点击后每一行后执行的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if([indexPath row] == ([newsList count])) { 
        
    }else{
        
        NewsDetailViewController *nextController = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
        NSDictionary *item = (NSDictionary *)[newsList objectAtIndex:indexPath.row];
        NSString *title=[item objectForKey:@"article_title"];
        NSString *date=[item objectForKey:@"article_date"];
        NSString *source=[item objectForKey:@"article_from"];
        //NSString *content=[item objectForKey:@"article_text"  ];
        NSString *newsID=[item objectForKey:@"id"];
        
        NSMutableArray * tempMA=[LoadNews getNewsContent:newsID tabWidget:currentMainTab label:currentSubTab naviAct:nil] ;
        NSDictionary *tempDic=(NSDictionary *)[tempMA objectAtIndex:0];
        NSString *content=[tempDic objectForKey:@"article_text"  ];
        
        [nextController setTitleAndContent:newsID tabWidget:currentMainTab label:currentSubTab newsTitle:title date:date
                                    source:source content:content];
        
        [[self parentViewController] presentModalViewController:nextController animated:false];
    }
    //[self.view addSubview:nextController.view];
    //[self presentModalViewController:nextController animated:true];
    
    //[self.view removeFromSuperview];
    
   // self.view.hidden=true;
    
   //[self resignFirstResponder];
    //[self.navigationController pushViewController:nextController animated:YES];
    
   // [nextController changeProductText:[newsList objectAtIndex:indexPath.row]];
}


//表的行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [newsList count]+1; // [newsList count];
}

/*
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *CellIdnetifier=@"cell";
    UITableViewCell *cell= (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdnetifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdnetifier] autorelease];
    }
    [[cell textLabel] setText:[newsList objectAtIndex:indexPath.row]];
    return cell;
}
 */



//选项卡选项得到数据
-(IBAction)getNews:(NSString*)newsClass {
    //NSString *newsClass;
     
    currentSubTab=newsClass ;
        
    NSString* currIndex=[newsIndexStatus objectForKey:currentSubTab];
    NSLog(@"getnews:  %@", currIndex);
    
    int page=[currIndex intValue];  
    newsList=[LoadNews getNewsList:TAB_GOV label:currentSubTab province_id:provinceID area_code:areaCode begin_index:(page-1)*20+1 end_index:(page)*20+1];
             
    [newsListView reloadData];
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
    [super dealloc];
    [newsClassChoice release];
    [newsListView release];
    [govBroadCastItem release];
    [govInfoItem release];
    [localNewsItem release];
    [nationalNewsItem release];
    
    [newsList release];
    [newsTitleLabel release];
    
    [currentMainTab release];
    [currentSubTab release];
    
    [newsIndexStatus release];
    [provinceID release];
    [areaCode release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)initTheData{
    //subTabName=GlobalVariableStore.TAB_GOV_NOTI;
    currentMainTab=TAB_GOV;
    currentSubTab=TAB_GOV_NOTI ;
    provinceID=[GlobalVariableStore sharedInstance].provinceId;
    areaCode=[GlobalVariableStore sharedInstance].city;
    
    NSArray *keys=[NSArray arrayWithObjects: TAB_GOV_NOTI , TAB_GOV_MESS, TAB_LOCAL_NEWS, TAB_NATIONAL_BRIE, nil];
    NSArray *objects=[NSArray arrayWithObjects:@"1",@"1",@"1",@"1",nil];
    
    newsIndexStatus=[NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    //NSLog(@"vdidload:   %@", [newsIndexStatus objectForKey:@"tab_government_mess"] );
    
    
    [newsIndexStatus retain];
    
    NSLog(@"--------------%d",[newsIndexStatus retainCount]);
    
    // Do any additional setup after loading the view from its nib.
    
    newsList=[LoadNews getNewsList:TAB_GOV label:currentSubTab province_id:provinceID area_code:areaCode begin_index:1 end_index:21];
    
    
    provinceArray = [LoadNews getProvinceAndId];
    cityArray = [LoadNews getCityAndId:@"1"];
    cityLable.text = [GlobalVariableStore sharedInstance].cityName;
    userLable.text = [GlobalVariableStore sharedInstance].nickName;
    
    [newsListView reloadData];
    
    [govBroadCastItem setStyle:UIBarButtonItemStyleDone];    
    [govInfoItem setStyle:UIBarButtonItemStyleBordered];
    [localNewsItem setStyle:UIBarButtonItemStyleBordered];
    [nationalNewsItem setStyle:UIBarButtonItemStyleBordered];
    
    
    
}



//每次打开视图初始化数据
- (void)viewWillAppear:(BOOL)animated{
    [self initTheData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self initTheData];
    //[newsIndexStatus setValue:@"1"  forKey: TAB_GOV_NOTI ];
    
   // newsList=[LoadNews getNewsList:@"" newsSubclass:@"" newsBeginIndex:0 newsEndIndex:NEWS_NUMBER_OF_ONEPAGE-1];
   // currentPage=1;
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
