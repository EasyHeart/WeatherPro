//
//  WPViewController.m
//  WeatherPro
//
//  Created by liuhang on 14-4-30.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "WPManager.h"
#import "WPNavigationController.h"

@interface WPViewController ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *blurredImageView;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGFloat screenHeight;
@property (strong, nonatomic) NSDateFormatter *hourlyFormatter;
@property (strong, nonatomic) NSDateFormatter *dailyFormatter;

@end

@implementation WPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.title = @"今日天气";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"目录"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(WPNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    UIImage *background = [UIImage imageNamed:@"bg"];
    self.backgroundImageView = [[UIImageView alloc]initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc]init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0.2;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    // 设置各种控件的Frame属性
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - hiloHeight, headerFrame.size.width - (2*inset), hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - (temperatureHeight + hiloHeight) , headerFrame.size.width - (2*inset), temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2*inset) +iconHeight) +10);
    conditionsFrame.origin.x =iconFrame.origin.x + (iconHeight + 10);
    
    //创建控件
    
    UIView *header = [[UIView alloc]initWithFrame:headerFrame];
    header.backgroundColor =[UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    //bottom left
    UILabel *temperatureLabel = [[UILabel alloc]initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor =[UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:120];
    [header addSubview:temperatureLabel];
    
    UILabel *hiloLabel = [[UILabel alloc]initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"0˚ / 0˚";
    hiloLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:hiloLabel];
    
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 68 , 280, 64) ];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Loading...";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];
    
    UILabel *conditionLabel = [[UILabel alloc]initWithFrame:conditionsFrame ];
    conditionLabel.backgroundColor = [UIColor clearColor];
    conditionLabel.textColor = [UIColor whiteColor];
    conditionLabel.text = @"Clear";
    conditionLabel.font = [UIFont fontWithName:@"HelverticalNeue-Light" size:18];
    [header addSubview:conditionLabel];
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:iconView];
    
    [[RACObserve([WPManager sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WPCondition *newCondition) {
         temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",newCondition.temperature.floatValue];
         conditionLabel.text = [newCondition.condition capitalizedString];
         cityLabel.text = [newCondition.locationName capitalizedString];
         
         iconView.image = [UIImage imageNamed:[newCondition imageName]];
     }];
    
    //合并信号,并获得两者的最新值,转换成一个单一的数据
    RAC(hiloLabel, text) = [[RACSignal combineLatest:@[RACObserve([WPManager sharedManager], currentCondition.tempHigh),RACObserve([WPManager sharedManager], currentCondition.tempLow)] reduce:^(NSNumber *highNum, NSNumber *lowNum) {
        return [NSString stringWithFormat:@"%.0f / %.0f",highNum.floatValue,lowNum.floatValue];
    }]
                            deliverOn:RACScheduler.mainThreadScheduler]; //传递数据到主线程
    
    
    //观察值变化,重新加载表视图
    [[RACObserve([WPManager sharedManager], hourlyForecast)
      deliverOn:RACScheduler.mainThreadScheduler ]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
    
    [[RACObserve([WPManager sharedManager], dailyForecast)
      deliverOn:RACScheduler.mainThreadScheduler ]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
    
    

    
    [[WPManager sharedManager] findCurrentLocation];  //开始查找当前位置
    
}

- (id)init
{
    if (self == [super init] ) {
        _hourlyFormatter = [[NSDateFormatter alloc]init];
        _dailyFormatter = [[NSDateFormatter alloc]init];
        
        _hourlyFormatter.dateFormat = @"h a";
        _dailyFormatter.dateFormat = @"EEEE";
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title
{
    cell.textLabel.font = [UIFont fontWithName:@"heleveticaNeue-Mudium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

- (void)configureHourlyCell: (UITableViewCell *)cell weather:(WPCondition *)weather
{
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticalNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f",weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:weather.imageName];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configureDailyCell: (UITableViewCell *)cell weather:(WPCondition *)weather
{
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticalNeue-Medium" size:18];
    cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f / %.0f",weather.tempHigh.floatValue,weather.tempLow.floatValue];
    cell.imageView.image = [UIImage imageNamed:weather.imageName];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return MIN([[WPManager sharedManager].hourlyForecast count], 6)+1;
    }
    return MIN([[WPManager sharedManager].dailyForecast count], 6)+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    //TODO: setup the cell
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"每小时预报"];
        } else {
            WPCondition *weather = [WPManager sharedManager].hourlyForecast[indexPath.row - 1];
            [self configureHourlyCell:cell weather:weather];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"每日预报"];
        } else {
            WPCondition *weather = [WPManager sharedManager].dailyForecast[indexPath.row -1];
            [self configureDailyCell:cell weather:weather];
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount ;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position/height, 1.0);
    self.blurredImageView.alpha = percent;
}

@end
