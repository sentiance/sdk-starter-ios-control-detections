//
//  AppDelegate.h
//  SDKStarter
//
//  Created by Roel Berger on 11/05/16.
//  Copyright © 2016 Sentiance. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SENTTransportDetectionSDK/SENTTransportDetectionSDK.h>

#define AUTO_START_SDK FALSE

// The appdelegate confirms to SENTTransportDetectionSDKDelegate protocol
@interface AppDelegate : UIResponder <UIApplicationDelegate, SENTTransportDetectionSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

// Keep a strong reference to a single instance of the SDK
@property (strong, atomic) SENTTransportDetectionSDK *sentianceSdk;

@end

