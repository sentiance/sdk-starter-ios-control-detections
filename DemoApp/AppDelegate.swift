//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Gustavo Nascimento on 6/8/18.
//  Copyright © 2018 Sentiance. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let APPID = ""
    let SECRET = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let config = SENTConfig(appId: APPID, secret: SECRET, launchOptions: launchOptions)

        // Use the following flag if you want to enable the triggered mode. Refer to the documentation for more details.
        //config?.isTriggeredTrip = true


        let sdk = SENTSDK.sharedInstance()

        sdk?.initWith(config, success: {
            self.sdkDidInit()
            self.startSdk()
        }, failure: { (issue) in
            print("Error when iniating the Sentiance SDK")
        })

        return true
    }

    func sdkDidInit() {
        guard let sdk = SENTSDK.sharedInstance() else {
            assertionFailure("SDK is nil")
            return
        }

        guard let userid = sdk.getUserId() else {
            assertionFailure("userid is nil")
            return
        }

        print("SDK user id: \(userid)")

        sdk.getUserAccessToken({ (token) in
            guard let uToken = token else {
                assertionFailure("token is nil")
                return
            }
            print("SDK token: \(uToken)")
        }) {
            print("Token could not be retrieved")
        }

        let notificationName = Notification.Name("SdkAuthenticationSuccess")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }


    func startSdk() {
        let sdk = SENTSDK.sharedInstance()
        sdk?.start({ status in
            guard let uStatus = status else {
                assertionFailure("status is nil")
                return
            }
            if (uStatus.startStatus == .started) {
                print("SDK started properly")
            } else if (uStatus.startStatus == .pending) {
                print("Something prevented the SDK to start properly (see location permission settings). Once fixed, the SDK will start automatically")
            } else {
                print("SDK did not start")
            }
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

