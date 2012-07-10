//
//  AreaViewController.m
//  TabbedConversion
//
//  Created by lin xiaoyu on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConvenienceSearchTab.h"
#import "GlobalVariableStore.h"
#import "LoadNews.h"
#import "ConvenienceDetail.h"
#import "TianYiBaoAppDelegate.h"
#import "SDImageView+SDWebCache.h"


@implementation ConvenienceSearchTab

@synthesize selectsTable;
@synthesize selectsList,provinceArray,cityArray;
@synthesize peopleItem,publicItem,corItem,changeCity,cityLable,nameLable;
@synthesize currentTab,currentSubTab,provinceID,areaCode;
@synthesize tabStatus;


//便民查询
- (IBAction)govPeople:(id)sender {
    [peopleItem setStyle:UIBarButtonItemStyleDone];
    [publicItem setStyle:UIBarButtonItemStyleBordered];
    [corItem setStyle:UIBarButtonItemStyleBordered];
    [self getSelected:TAB_GOV_PEO];
}

//公众办事
- (IBAction)govPublic:(id)sender {
    [peopleItem setStyle:UIBarButtonItemStyleBordered];
    [publicItem setStyle:UIBarButtonItemStyleDone];
    [corItem setStyle:UIBarButtonItemStyleBordered];
    [self getSelected:TAB_GOV_PUB];
}

//企业办事
- (IBAction)govCorp:(id)sender {
    [peopleItem setStyle:UIBarButtonItemStyleBordered];
    [publicItem setStyle:UIBarButtonItemStyleBordered];
    [corItem setStyle:UIBarButtonItemStyleDone];
    [self getSelected:TAB_GOV_COR];
}


//获得选中的选项,列表重导数据
- (void)getSelected:(NSString *)mySelected{
    currentSubTab=mySelected ;
    
    selectsList=[LoadNews getSelectsList:TAB_SELECTS lable:currentSubTab province_id:provinceID area_code:areaCode];
    
    [selectsTable reloadData];
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
        [GlobalVariableStore sharedInstance].cityName=cityLable.text;
        
        provinceID = getMyProvinceId;
        areaCode = getMyCityId;
        selectsList = [LoadNews getSelectsList:TAB_SELECTS lable:currentSubTab province_id:provinceID area_code:areaCode];
        
        
        [self.selectsTable reloadData];
        
        [[[sender superview] superview] removeFromSuperview];
        self.changeCity = nil;
    }
}

- (IBAction)chooseProvinceAndCity:(id)sender {
    [self showPickers];
}







//设置每一行表的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

//设置行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [selectsList count];
}

//设置列表项的块数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置没一行显示的内容
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=nil;
    NSString *ViewCellIdentifier=@"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    if (cell == nil)
        cell = [[[NewsListCustomCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:ViewCellIdentifier] autorelease];
    UIView *cellView;
    cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    
    NSDictionary *item = (NSDictionary *)[selectsList objectAtIndex:indexPath.row];//每一个表个对应的selectList数据
    [cell.imageView setTransform:CGAffineTransformMakeScale(0.38, 0.38)];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"article_img"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"nsnj.jpg"]];
    
    
//    //启动一个新的子线程来执行加载图片的方法
//    [NSThread detachNewThreadSelector:@selector(getImageForCellAtIndexPath:) toTarget:self withObject:indexPath];
//    //设置cell自带imageView的大小
//    [cell.imageView setTransform:CGAffineTransformMakeScale(0.38, 0.38)];
//    [cell.imageView setImage:[UIImage imageNamed:@"nsnj.jpg"]];
    
    
    
//    //先到Library/Caches/ 目录下找图片 如果没有 就使用默认图片
//    NSString *imageName = [[[self.selectsList objectAtIndex:indexPath.row] valueForKey:@"article_img"] stringByAppendingString:@".temp"];
//    
//    NSString *imageDataPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:imageName];
//    
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageDataPath]]; 
//    if (image) { 
//        cell.imageView.image = image; 
//    } else {
//        //placeholder为在未加载完成加载图片时显示的默认图片
//        cell.imageView.image = [UIImage imageNamed:@"nsnj.jpg"];  
//    }
    
    //每一行的标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(76, 14, 100, 34)];
    titleLable.textColor=[UIColor blackColor];
    titleLable.text = [item objectForKey:@"article_title"];
    [cellView addSubview:titleLable];
    [titleLable release];
    
    ((NewsListCustomCell *)cell).view = cellView;
    
    [cellView release];
    return cell;
}

////异步1
//-(void)getImageForCellAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *item = (NSDictionary *)[selectsList objectAtIndex:indexPath.row];//每一个表个对应的selectList数据
//    
//    //每一列的图标
//    NSString *imagePath = [item objectForKey:@"article_img"];//获得图片的路径
//    NSURL *url = [NSURL URLWithString:imagePath];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    UIImage *image = [[UIImage alloc] initWithData:data];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 62, 44)];
//    imageView.image = image;
//    
//    [image release];
//    
//    UITableViewCell *cell = [self.selectsTable cellForRowAtIndexPath:indexPath];
//    
//    [cell performSelectorOnMainThread:@selector(addSubview:) withObject:imageView waitUntilDone:NO];
//    
//    [imageView release];
//}



////异步2
//-(void)getImageForCellAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *item = (NSDictionary *)[selectsList objectAtIndex:indexPath.row];//每一个表个对应的selectList数据
//    
//    //每一列的图标
//    NSString *imagePath = [item objectForKey:@"article_img"];//获得图片的路径
//    NSURL *url = [NSURL URLWithString:imagePath];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
//    
//    UITableViewCell *cell = [self.selectsTable cellForRowAtIndexPath:indexPath];
//    
//    [cell.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
//}



//-(void)loadCellImage
//{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    // 获得 table 当前显示的cells
//    NSArray *indexPathsForLoad = [self.selectsTable indexPathsForVisibleRows];
//    
//    for (NSIndexPath *item in indexPathsForLoad) {
//        
//        NSInteger rowNumberForCell = item.row;
//        
//        NSString *imageStr = [[self.selectsList objectAtIndex:rowNumberForCell]objectForKey:@"article_img"];
//        
//        NSString *imageName = [[[self.selectsList objectAtIndex:rowNumberForCell]valueForKey:@"article_img"]stringByAppendingString:@".temp"];
//        
//        NSString *imageDataPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:imageName];
//        
//        if (![[NSFileManager defaultManager]fileExistsAtPath:imageDataPath]) {
//            
//            NSLog(@"文件不存在！");
//            //先判断Library/Caches/ 这个目录下有没有这个文件如果没有 就写入目录
//            NSURL *imageurl = [NSURL URLWithString:[imageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSData *imageData = [NSData dataWithContentsOfURL:imageurl];
//            [imageData writeToFile:imageDataPath atomically:YES];
//            
//            if (![imageData writeToFile:imageDataPath atomically:YES]) {
//                NSLog(@"xieru buchengong");
//            }
//            
//            UIImage *image = [UIImage imageWithData:imageData];
//            UITableViewCell *cell = [self.selectsTable cellForRowAtIndexPath:item];
//            cell.imageView.image = image;// 更新cell的 image
//        }
//    }
//    [pool release];
//}


//设置点击每一行的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    ConvenienceDetail *nextController = [[ConvenienceDetail alloc] initWithNibName:@"ConvenienceDetail" bundle:nil];
    NSDictionary *item = (NSDictionary *)[selectsList objectAtIndex:row];
    NSString *webSite = [item objectForKey:@"http_url"];
    
    nextController.webSite = webSite;//直接把值传递过去

    [[self parentViewController] presentModalViewController:nextController animated:false];
    [nextController release];
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
    [selectsTable release];
    [selectsList release];
    [peopleItem release];
    [publicItem release];
    [corItem release];
    
    [provinceArray release];
    [cityArray release];
    
    [changeCity release];
    [cityLable release];
    
    [currentTab release];
    [currentSubTab release];
    [provinceID release];
    [areaCode release];
    [tabStatus release];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)initTheData{
    
    currentTab = TAB_SELECTS;
    currentSubTab = TAB_GOV_PEO;//页面打开当前列表
    
    provinceID=[GlobalVariableStore sharedInstance].provinceId;
    areaCode=[GlobalVariableStore sharedInstance].city;
    
    NSArray *keys=[NSArray arrayWithObjects: TAB_GOV_PEO , TAB_GOV_PUB, TAB_GOV_COR, nil];
    NSArray *objects=[NSArray arrayWithObjects:@"1",@"1",@"1",nil];
    
    tabStatus = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [tabStatus retain];
    
    selectsList = [LoadNews getSelectsList:TAB_SELECTS lable:currentSubTab province_id:provinceID area_code:areaCode];
    
    [selectsTable reloadData];
    
    cityLable.text = [GlobalVariableStore sharedInstance].cityName;
    nameLable.text = [GlobalVariableStore sharedInstance].nickName;
    
    provinceArray = [LoadNews getProvinceAndId];
    cityArray = [LoadNews getCityAndId:@"1"];
    
    [peopleItem setStyle:UIBarButtonItemStyleDone];
    [publicItem setStyle:UIBarButtonItemStyleBordered];
    [corItem setStyle:UIBarButtonItemStyleBordered];
}

- (void)viewWillAppear:(BOOL)animated{
    [self initTheData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"%d==========================",[selectsList count]);
    //NSLog(@"--------------------%@=============================",selectsList);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [selectsList release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end