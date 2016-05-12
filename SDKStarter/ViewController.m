//
//  ViewController.m
//  SDKStarter
//
//  Created by Roel Berger on 11/05/16.
//  Copyright © 2016 Sentiance. All rights reserved.
//

#import "ViewController.h"

#import <SENTTransportDetectionSDK/SENTTransportDetectionSDK.h>
#import <SENTTransportDetectionSDK/SENTStatusMessage.h>
#import "AppDelegate.h"

@interface ViewController () 

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    
    // Set up the header of the table view to START/STOP detections
    if (pTableHeaderView == nil) {
        
        
        pTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [pTableHeaderView setBackgroundColor:[UIColor whiteColor]];
        
        if (self.startstopButton == nil) {
            
            self.startstopButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            [self.startstopButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:43.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [self.startstopButton setTitle:@"Start Detections" forState:UIControlStateNormal];
            [self.startstopButton addTarget:self action:@selector(startStopDetectionsTapped:) forControlEvents:UIControlEventTouchUpInside];
            [pTableHeaderView addSubview:self.startstopButton];
        }
    }
 
    // Refresh status of the sdk usage when view appears
    [self refreshStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Our AppDelegate broadcasts when sdk auth was successful
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshStatus)
                                                 name:@"SdkAuthenticationSuccess"
                                               object:nil];
    
    // Set up timer to refresh sdk status every 5 seconds
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshStatus) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopDetectionsTapped:(id)sender {
    
    // Handling the start/stop detections events from user
    if ([self.startstopButton.titleLabel.text isEqualToString:@"Start Detections"])
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).sentianceSdk startDetections];
    else
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).sentianceSdk stopDetections];
}


#pragma mark - UITableView delegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return pTableHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return sdkInfoData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"StatusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Set cell data
    [cell.textLabel setText:[sdkInfoData objectAtIndex:indexPath.row]];
    [cell.textLabel setMinimumScaleFactor:0.8];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

#pragma mark UIRefresh section

- (void) refreshStatus {
    
    // Refresh the staus of the sdk in the table data source.
    // Every item in this data source is displayed in the table view.
    // You can use the status message for more information

    SENTStatusMessage* sdkStatus = [((AppDelegate *)[[UIApplication sharedApplication] delegate]).sentianceSdk getStatusMessage];
    NSString *flavor = [SENTTransportDetectionSDK getSDKFlavor];
    
    sdkInfoData = [[NSMutableArray alloc] init];
    [sdkInfoData addObject:[NSString stringWithFormat:@"SDK Flavor : %@", flavor]];
    [sdkInfoData addObject:[NSString stringWithFormat:@"SDK Version : %@", [SENTTransportDetectionSDK getSDKVersion]]];
    [sdkInfoData addObject:[NSString stringWithFormat:@"User ID : %@", [SENTTransportDetectionSDK getUserId]]];
    
    
    //    [sdkInfoData addObject:[NSString stringWithFormat:@"User Token : %@", [SENTTransportDetectionSDK getUserToken]]];
    
    
    NSArray *sdkIssuesArray = @[@"SDK_LocationPermissionIssue", @"SDK_SensorPermissionIssue", @"SDK_NetworkPermissionIssue", @"SDK_BGAccessPermissionIssue", @"SDK_DiskUsePermissionIssue", @"SDK_GpsIssue", @"SDK_GyroscopeIssue", @"SDK_MotionsensorIssue", @"SDK_AccelerometerIssue", @"SDK_PlatformIssue", @"SDK_ManufacturerIssue", @"SDK_ModelIssue", @"SDK_OSIssue", @"SDK_SDKVersionIssue", @"SDK_DiskQuotaExceeded", @"SDK_WifiQuotaExceeded", @"SDK_MobileQuotaExceeded"];
    
    
    [sdkInfoData addObject:[NSString stringWithFormat:@"Status : %@", sdkStatus.mode == SDKMode_SUPPORTED ? @"SUPPORTED" : @"UNSUPPORTED"]];
    if (sdkStatus.mode == SDKMode_UNSUPPORTED && [sdkStatus.issues count] > 0) {
        
        for (SDKIssue* issue in sdkStatus.issues) {
            
            [sdkInfoData addObject:[NSString stringWithFormat:@"Issue : %@", [sdkIssuesArray objectAtIndex:issue.type-1]]];
        }
    }
    
    [sdkInfoData addObject:[NSString stringWithFormat:@"WIFIData : %llu/%llu", sdkStatus.wifiQuotaUsed, sdkStatus.wifiQuotaLimit]];
    [sdkInfoData addObject:[NSString stringWithFormat:@"MobileData : %llu/%llu", sdkStatus.mobileQuotaUsed, sdkStatus.mobileQuotaLimit]];
    [sdkInfoData addObject:[NSString stringWithFormat:@"Disk : %llu/%llu", sdkStatus.diskQuotaUsed, sdkStatus.diskQuotaLimit]];
    
    NSDate* lastWIFIDate = [NSDate dateWithTimeIntervalSince1970:sdkStatus.wifiLastSeenTimestamp/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* csDate = [formatter stringFromDate:lastWIFIDate];
    [sdkInfoData addObject:[NSString stringWithFormat:@"Last WIFI Access: %@", csDate != nil ? csDate : [NSString stringWithFormat:@"%llu", sdkStatus.wifiLastSeenTimestamp]]];
    
    if (sdkStatus.isDetecting) {
        
        [self.startstopButton setTitle:@"Stop Detections" forState:UIControlStateNormal];
    }
    else {
        [self.startstopButton setTitle:@"Start Detections" forState:UIControlStateNormal];
    }
    
    [self.pInfoTableview reloadData];
}

@end
