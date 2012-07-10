//
//  FinanceNewsTab.m
//  TianYiBao
//
//  Created by lin xiaoyu on 12-5-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "FinanceNewsTab.h"
#import "GlobalVariableStore.h"
#import "LoadNews.h"
#import "NewsListCustomCell.h"
#import "NewsDetailViewController.h"

#define PAGE_SIZES 20
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation FinanceNewsTab

@synthesize FinanceListView,newsItem,corpItem,dataItem,fofItem,debeItem;
@synthesize FinanceList,currentMainTab,currentSubTab,subTabStatus;


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
    [FinanceListView release];
    [newsItem release];
    [corpItem release];
    [dataItem release];
    [fofItem release];
    [debeItem release];
    [FinanceList release];
    [currentMainTab release];
    [currentSubTab release];
    [subTabStatus release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)initTheData{
    currentMainTab = TAB_FINANCE;
    currentSubTab = TAB_FINANCE_NEWS;
    
    NSArray *keys=[NSArray arrayWithObjects: TAB_FINANCE_NEWS, TAB_FINANCE_CORP, TAB_FINANCE_DATA, TAB_FINANCE_FOF, TAB_FINANCE_DEBE,nil];
    NSArray *objects=[NSArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",nil];
    subTabStatus = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [subTabStatus retain];
    
    FinanceList = [LoadNews getFinanceNewsWithTabWidget:TAB_FINANCE lable:TAB_FINANCE_NEWS begin_index:1 end_index:21];
    [newsItem setStyle:UIBarButtonItemStyleDone];
    [corpItem setStyle:UIBarButtonItemStyleBordered];
    [dataItem setStyle:UIBarButtonItemStyleBordered];
    [fofItem setStyle:UIBarButtonItemStyleBordered];
    [debeItem setStyle:UIBarButtonItemStyleBordered];

}

//- (void)viewWillAppear:(BOOL)animated{
//    [self initTheData];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTheData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//加载更多
-(void) loadMore{
//    NSMutableArray *more = [[NSMutableArray alloc] initWithCapacity:0];
    
//    NSString *curIndex = [[NSString alloc]init];
//    curIndex = [subTabStatus objectForKey:currentSubTab];
    
    //无需手动释放
    NSString *curIndex = [NSString stringWithString:[subTabStatus objectForKey:currentSubTab]];
    
    int page = [curIndex intValue];
    NSMutableArray *more = [LoadNews getFinanceNewsWithTabWidget:TAB_FINANCE lable:currentSubTab begin_index:page*20+1 end_index:(page+1)*20+1];
    [subTabStatus setValue:[NSString stringWithFormat:@"%d",page+1] forKey:currentSubTab];
    [self performSelectorOnMainThread:@selector(appendListWith:) withObject:more waitUntilDone:NO];
//    [more release];
}

-(void) appendListWith:(NSMutableArray *)newData{
    [FinanceList addObjectsFromArray:newData];
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:PAGE_SIZES];
    for (int ind = 0; ind<6; ind++) {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[FinanceList indexOfObject:[newData objectAtIndex:ind]] inSection:0]; 
        [insertIndexPaths addObject:newPath];
    }
    [self.FinanceListView reloadData];
}

//工具栏上的按钮获得数据
-(IBAction)getNews:(NSString*)newsClass {
    currentSubTab=newsClass ;
    
    NSString* currIndex=[subTabStatus objectForKey:currentSubTab];
    NSLog(@"getnews:  %@", currIndex);
    
    int page=[currIndex intValue]; 
    FinanceList = [LoadNews getFinanceNewsWithTabWidget:TAB_FINANCE lable:currentSubTab begin_index:(page-1)*20+1 end_index:page*20+1];
    
    [FinanceListView reloadData];
}

-(IBAction)getMyData:(NSInteger)parentId back:(NSString*)orientation{
    FinanceList = [LoadNews getFinanceDataWithTabWidget:TAB_FINANCE lable:TAB_FINANCE_DATA parent:parentId orientation:orientation];
    [FinanceListView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(currentSubTab == TAB_FINANCE_DATA){
        return [FinanceList count];
    }else{
        return [FinanceList count]+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=nil;
    NSString *ViewCellIdentifier=@"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    if (cell == nil)
        cell = [[[NewsListCustomCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:ViewCellIdentifier] autorelease];
    UIView *cellView;
    
    if (currentSubTab==TAB_FINANCE_NEWS || currentSubTab==TAB_FINANCE_CORP) {
        //判断是否要显示查看更多的一行
        if([indexPath row] == ([FinanceList count])) { 
            
            cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            
            UIButton *moreButton;
            
            moreButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [cellView addSubview:moreButton];
            [moreButton setFrame:CGRectMake(60, 15, 200, 30)];
            [moreButton setBackgroundColor:[UIColor whiteColor]];
            [moreButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal ];
            [moreButton setTitle:@"...点击显示更多..."   forState:  UIControlStateNormal ];
            
            [moreButton addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            ((NewsListCustomCell *)cell).view = cellView;
            
            [cellView release];
            
            return  cell;
        }else{
            cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
            
            NSDictionary *item = (NSDictionary *)[FinanceList objectAtIndex:indexPath.row];
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"imageKey" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            UIImageView *theIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 44, 44)];
            theIcon.image = image;
            [cellView addSubview:theIcon];
            [theIcon release];
            
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(52, 4, 270, 15)];
            titleLable.textColor = RGBA(67, 110, 238, 1);
            titleLable.text = [item objectForKey:@"article_title"];
            [cellView addSubview:titleLable];
            [titleLable release];
            
            UILabel *newsDateInCell= [[UILabel alloc] initWithFrame:CGRectMake(52, 22, 100, 15)];
            newsDateInCell.textColor=RGBA(178, 34, 34, 1); 
            newsDateInCell.text=[item objectForKey:@"article_date"];
            [cellView addSubview:newsDateInCell];
            [newsDateInCell release];
            
            UILabel *newsSourceInCell= [[UILabel alloc] initWithFrame:CGRectMake(150, 22, 150, 15)];
            newsSourceInCell.text=[item objectForKey:@"article_from"];
            newsSourceInCell.textColor=RGBA(205, 201, 201, 1); 
            [cellView addSubview:newsSourceInCell];
            [newsSourceInCell release];
            
            UILabel *newsContAbsInCell= [[UILabel alloc] initWithFrame:CGRectMake(52, 40, 270, 15)];
            newsContAbsInCell.textColor=[UIColor blackColor];
            [newsContAbsInCell setText:[item objectForKey:@"article_text"]];
            [cellView addSubview:newsContAbsInCell];
            [newsContAbsInCell release];
            ((NewsListCustomCell *)cell).view = cellView;
            
            [cellView release];
            
            return cell;
        }
    }else if(currentSubTab == TAB_FINANCE_DATA){
        NSLog(@"%d",indexPath.row);
        
        cellView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
        NSDictionary *item = (NSDictionary *)[FinanceList objectAtIndex:indexPath.row];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"imageKey" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        UIImageView *theIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 44, 44)];
        theIcon.image = image;
        [cellView addSubview:theIcon];
        [theIcon release];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(52, 22, 270, 15)];
        titleLable1.textColor = [UIColor blackColor];
        titleLable1.text = [item objectForKey:@"article_title"];
        [cellView addSubview:titleLable1];
        [titleLable1 release];
        
        ((NewsListCustomCell *)cell).view = cellView;
        
        [cellView release];
        return cell;
    }else{
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (currentSubTab==TAB_FINANCE_NEWS || currentSubTab==TAB_FINANCE_CORP) {
        if([indexPath row] == ([FinanceList count])) { 
            
        }else{
            NewsDetailViewController *nextController = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
            NSDictionary *item = (NSDictionary *)[FinanceList objectAtIndex:indexPath.row];
            NSString *title=[item objectForKey:@"article_title"];
            NSString *date=[item objectForKey:@"article_date"];
            NSString *source=[item objectForKey:@"article_from"];
            NSString *newsID=[item objectForKey:@"id"];
            NSMutableArray * tempMA=[LoadNews getNewsContent:newsID tabWidget:currentMainTab label:currentSubTab naviAct:nil] ;
            NSDictionary *tempDic=(NSDictionary *)[tempMA objectAtIndex:0];
            NSString *content=[tempDic objectForKey:@"article_text"];
            
            [nextController setTitleAndContent:newsID tabWidget:currentMainTab label:currentSubTab newsTitle:title date:date source:source content:content];
            [[self parentViewController] presentModalViewController:nextController animated:false];
            [nextController release];
        }
    }else if(currentSubTab == TAB_FINANCE_DATA){
        NSDictionary *item = (NSDictionary *)[FinanceList objectAtIndex:indexPath.row];
        NSString *newId = [item objectForKey:@"id"]; 
        [self getMyData:[newId intValue] back:nil];
//        currentSubTab = @"secondTab";
    }else{
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)getNewsClick:(id)sender {
    [newsItem setStyle:UIBarButtonItemStyleDone];
    [corpItem setStyle:UIBarButtonItemStyleBordered];
    [dataItem setStyle:UIBarButtonItemStyleBordered];
    [fofItem setStyle:UIBarButtonItemStyleBordered];
    [debeItem setStyle:UIBarButtonItemStyleBordered];
    currentSubTab = TAB_FINANCE_NEWS;
    [self getNews:TAB_FINANCE_NEWS];
}

- (IBAction)getCorClick:(id)sender {
    [newsItem setStyle:UIBarButtonItemStyleBordered];
    [corpItem setStyle:UIBarButtonItemStyleDone];
    [dataItem setStyle:UIBarButtonItemStyleBordered];
    [fofItem setStyle:UIBarButtonItemStyleBordered];
    [debeItem setStyle:UIBarButtonItemStyleBordered];
    currentSubTab = TAB_FINANCE_CORP;
    [self getNews:TAB_FINANCE_CORP];
}

- (IBAction)getDataClick:(id)sender {
    [newsItem setStyle:UIBarButtonItemStyleBordered];
    [corpItem setStyle:UIBarButtonItemStyleBordered];
    [dataItem setStyle:UIBarButtonItemStyleDone];
    [fofItem setStyle:UIBarButtonItemStyleBordered];
    [debeItem setStyle:UIBarButtonItemStyleBordered];
    currentSubTab = TAB_FINANCE_DATA;
    [self getMyData:0 back:nil];
    
    
}

- (IBAction)getFofClick:(id)sender {
//    [newsItem setStyle:UIBarButtonItemStyleBordered];
//    [corpItem setStyle:UIBarButtonItemStyleBordered];
//    [dataItem setStyle:UIBarButtonItemStyleBordered];
//    [fofItem setStyle:UIBarButtonItemStyleDone];
//    [debeItem setStyle:UIBarButtonItemStyleBordered];
//    [self getNews:TAB_FINANCE_FOF];
}

- (IBAction)getDebeClick:(id)sender {
//    [newsItem setStyle:UIBarButtonItemStyleBordered];
//    [corpItem setStyle:UIBarButtonItemStyleBordered];
//    [dataItem setStyle:UIBarButtonItemStyleBordered];
//    [fofItem setStyle:UIBarButtonItemStyleBordered];
//    [debeItem setStyle:UIBarButtonItemStyleDone];
//    [self getNews:TAB_FINANCE_DEBE];
}


@end
