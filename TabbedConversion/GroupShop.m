//
//  GroupShop.m
//  TianYiBao
//
//  Created by pauling on 12-6-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GroupShop.h"
#import "GlobalVariableStore.h"
#import "LoadNews.h"
#import "NewsListCustomCell.h"
#import "ConvenienceDetail.h"
#import "SDImageView+SDWebCache.h"


#define PAGE_SIZES 20
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation GroupShop

@synthesize bookListView,hotShopItem,bookMarketItem;
@synthesize bookList,currentMainTab,currentSubTab,subTabStatus;


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
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//加载更多
-(void) loadMore{
//    NSMutableArray *more = [[NSMutableArray alloc] initWithCapacity:0];
    
//    NSString *curIndex = [[NSString alloc]init];
//    curIndex = [subTabStatus objectForKey:currentSubTab];
    
    //无需手动释放
    NSString *curIndex = [NSString stringWithString:[subTabStatus objectForKey:currentSubTab]];
    
    int page = [curIndex intValue];
    NSMutableArray *more = [LoadNews getFinanceNewsWithTabWidget:TAB_GROUP lable:currentSubTab begin_index:page*20+1 end_index:(page+1)*20+1];
    //判断是否有更多的数据可以加载
    if ([more count]!=0) {
        [subTabStatus setValue:[NSString stringWithFormat:@"%d",page+1] forKey:currentSubTab];
        [self performSelectorOnMainThread:@selector(appendListWith:) withObject:more waitUntilDone:NO];
    }else{
        
    }
//    [more release];
}

-(void) appendListWith:(NSMutableArray *)newData{
    [bookList addObjectsFromArray:newData];
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:PAGE_SIZES];
    for (int ind = 0; ind<6; ind++) {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[bookList indexOfObject:[newData objectAtIndex:ind]] inSection:0]; 
        [insertIndexPaths addObject:newPath];
    }
    [self.bookListView reloadData];
}

- (void)initTheData{
    currentMainTab = TAB_GROUP;
    currentSubTab = TAB_GROUP_HOT;
    
    NSArray *keys=[NSArray arrayWithObjects: TAB_GROUP_HOT, TAB_GROUP_MARKET,nil];
    NSArray *objects=[NSArray arrayWithObjects:@"1",@"1",nil];
    subTabStatus = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [subTabStatus retain];
    
    bookList = [LoadNews getFinanceNewsWithTabWidget:TAB_GROUP lable:TAB_GROUP_HOT begin_index:1 end_index:21];
    [hotShopItem setStyle:UIBarButtonItemStyleDone];
    [bookMarketItem setStyle:UIBarButtonItemStyleBordered];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == [bookList count]) {
        return 62;
    }else{
        return 110;
    }
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [bookList count]+1;
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
    
    
    
    //判断是否要显示查看更多的一行
    if([indexPath row] == [bookList count]) { 
        
        cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        
        UIButton *moreButton;
        
        moreButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cellView addSubview:moreButton];
        [moreButton setFrame:CGRectMake(60, 15, 200, 30)];
        [moreButton setBackgroundColor:[UIColor whiteColor]];
        [moreButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal ];
        [moreButton setTitle:@"...点击查看更多..."   forState:  UIControlStateNormal ];
        
        [moreButton addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        ((NewsListCustomCell *)cell).view = cellView;
        
        [cellView release];
        
        return  cell;
    }else{
        cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        
        NSDictionary *item = (NSDictionary *)[bookList objectAtIndex:indexPath.row];
        NSURL* url = [NSURL URLWithString:[item objectForKey:@"prod_img"]];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 44, 70)];
        [imageView setImageWithURL:url refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"]];
        [cellView addSubview:imageView];
        
        //价格
        UILabel *priceLable= [[UILabel alloc] initWithFrame:CGRectMake(5, 85, 70, 16)];
        priceLable.text=[item objectForKey:@"prod_price"];
        priceLable.textColor=[UIColor redColor];
        priceLable.font = [UIFont fontWithName:@"TrebuchetMS" size:11];
        [cellView addSubview:priceLable];
        [priceLable release];
        
        //图书名称
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(80,0, 240, 35)];
        titleLable.textColor = RGBA(67, 110, 238, 1);
        titleLable.text = [item objectForKey:@"prod_title"];
        titleLable.font = [UIFont fontWithName:@"TrebuchetMS" size:14];
        titleLable.numberOfLines = 2;
        [cellView addSubview:titleLable];
        [titleLable release];
        
        //图书简介
        UILabel *newsDateInCell= [[UILabel alloc] initWithFrame:CGRectMake(80, 33, 240, 60)];
        newsDateInCell.textColor= [UIColor blackColor];
        newsDateInCell.numberOfLines = 3;
        newsDateInCell.font = [UIFont fontWithName:@"TrebuchetMS" size:12];
        newsDateInCell.text=[item objectForKey:@"prod_info"];
        [cellView addSubview:newsDateInCell];
        [newsDateInCell release];
        
        //点击次数
        UILabel *newsSourceInCell= [[UILabel alloc] initWithFrame:CGRectMake(80, 85, 240, 16)];
        newsSourceInCell.text=[item objectForKey:@"prod_click"];
        newsSourceInCell.textColor=[UIColor blackColor]; 
        newsSourceInCell.font = [UIFont fontWithName:@"TrebuchetMS" size:12];
        [cellView addSubview:newsSourceInCell];
        [newsSourceInCell release];
        
        ((NewsListCustomCell *)cell).view = cellView;
        
        [cellView release];
        
        return cell;
    }
}


//-(void)getImageForCellAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.row==[self.bookList count]) {
//        
//    }else{
//        NSDictionary *item2 = (NSDictionary *)[bookList objectAtIndex:indexPath.row];//每一个表个对应的selectList数据
//        //每一列的图标
//        NSString *imagePath = [item2 objectForKey:@"prod_img"];//获得图片的路径
//        NSURL *url = [NSURL URLWithString:imagePath];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [[UIImage alloc] initWithData:data];
//        
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 44, 70)];
//        imageView.image = image;
//        
//        UITableViewCell *cell = [self.bookListView cellForRowAtIndexPath:indexPath];
//        
//        [cell performSelectorOnMainThread:@selector(addSubview:) withObject:imageView waitUntilDone:NO];
//        
//        [imageView release]; 
//    }
//}




-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    
    if (row == [bookList count]) {
        
    }else{
        ConvenienceDetail *nextController = [[ConvenienceDetail alloc] initWithNibName:@"ConvenienceDetail" bundle:nil];
        NSDictionary *item = (NSDictionary *)[bookList objectAtIndex:row];
        NSString *webSite = [item objectForKey:@"http_url"];
        
        nextController.webSite = webSite;//直接把值传递过去
        
        [[self parentViewController] presentModalViewController:nextController animated:false];
        [nextController release];

    }
}


//工具栏上的按钮获得数据
-(IBAction)getNews:(NSString*)newsClass {
    currentSubTab=newsClass ;
    
    NSString* currIndex=[subTabStatus objectForKey:currentSubTab];
    NSLog(@"getnews:  %@", currIndex);
    
    int page=[currIndex intValue]; 
    bookList = [LoadNews getFinanceNewsWithTabWidget:TAB_GROUP lable:currentSubTab begin_index:(page-1)*20+1 end_index:page*20+1];
    
    [bookListView reloadData];
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

- (IBAction)getHotBuy:(id)sender {
    [hotShopItem setStyle:UIBarButtonItemStyleDone];
    [bookMarketItem setStyle:UIBarButtonItemStyleBordered];
    [self getNews:TAB_GROUP_HOT];
}

- (IBAction)getBookMaketList:(id)sender {
    [hotShopItem setStyle:UIBarButtonItemStyleBordered];
    [bookMarketItem setStyle:UIBarButtonItemStyleDone];
    [self getNews:TAB_GROUP_MARKET];
}


@end
