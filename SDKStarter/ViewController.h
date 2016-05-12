//
//  ViewController.h
//  SDKStarter
//
//  Created by Roel Berger on 11/05/16.
//  Copyright © 2016 Sentiance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *sdkInfoData;
    UIView* pTableHeaderView;
}

@property (strong, nonatomic) IBOutlet UIButton *startstopButton;
@property (weak, nonatomic) IBOutlet UITableView *pInfoTableview;

- (IBAction)startStopDetectionsTapped:(id)sender;

@end

