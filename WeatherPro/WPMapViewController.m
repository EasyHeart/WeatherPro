//
//  BIDViewController.m
//  Where ame I
//
//  Created by liuhang on 14-4-28.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPMapViewController.h"
#import "WPPlace.h"
#import "WPNavigationController.h"
#import <TSMessages/TSMessage.h>

@interface WPMapViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *previousPoint;
@property (assign, nonatomic) CLLocationDistance totalMovementDistance;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTraveledLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation WPMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"我的位置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"目录"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(WPNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate =self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation =NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSString *latitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.latitude];
    self.latitudeLabel.text= latitudeString;
    
    NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.longitude];
    self.longitudeLabel.text = longitudeString;
    
    NSString *altitudeString = [NSString stringWithFormat:@"%gm",newLocation.altitude];
    self.altitudeLabel.text = altitudeString;
    
    NSString *horizontalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.horizontalAccuracy];
    self.horizontalAccuracyLabel.text = horizontalAccuracyString;
    
    NSString *verticalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.verticalAccuracy];
    self.verticalAccuracyLabel.text = verticalAccuracyString;
    
    if (newLocation.verticalAccuracy <0 ||newLocation.horizontalAccuracy < 0) {
        //invalid accuracy
        return;
    }
    
    if (newLocation.horizontalAccuracy > 100||newLocation.verticalAccuracy >50){
        //too large radius
        return;
    }
    
    if (self.previousPoint == nil) {
        self.totalMovementDistance = 0;
        
        WPPlace *start = [[WPPlace alloc]init];
        start.coordinate = newLocation.coordinate;
        start.title = @"起点";
        start.subtitle = @"这里是我的起点";
        
        [self.mapView addAnnotation:start];
        MKCoordinateRegion region;
        region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 200, 200);
        
        [self.mapView setRegion:region animated:YES];
    } else {
        self.totalMovementDistance += [newLocation distanceFromLocation:self.previousPoint];
    }
    self.previousPoint = newLocation;
    
    NSString *distanceString = [NSString stringWithFormat:@"%gm",self.totalMovementDistance];
    self.distanceTraveledLabel.text = distanceString;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorType = (error.code == kCLErrorDenied)?@"获取权限失败" : @"未知错误";
   [TSMessage showNotificationWithTitle:@"获取当前位置失败" subtitle:errorType type:TSMessageNotificationTypeError];
}

@end
