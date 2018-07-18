//
//  ViewController.swift
//  DemoApp
//
//  Created by Gustavo Nascimento on 6/8/18.
//  Copyright © 2018 Sentiance. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tripDidStartLabel: UIButton!
    @IBOutlet weak var tripDidStopLabel: UIButton!
    
    let redColor = UIColor(red: 255/255, green: 61/255, blue: 73/255, alpha: 1)
    let greyColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationName = Notification.Name("SdkAuthenticationSuccess")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.refreshUserId), name: notificationName, object: nil)
        self.refreshUserId()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func refreshUserId()  {
        let sdk = SENTSDK.sharedInstance()!
        if sdk.isInitialised() {
            DispatchQueue.main.async {
                self.userIdLabel.text = sdk.getUserId()
                self.userIdLabel.isHidden = false
            }
        }
    }

    @IBAction func tripDidStart(_ sender: Any) {
        self.turnOnStop()

        let sdk = SENTSDK.sharedInstance()!

        sdk.startTrip([AnyHashable : Any](), transportModeHint: SENTTransportMode.unknown, success: {
            print("SDK external trip did start")
        }) { (status) in
            self.turnOnStart()
            print("SDK external trip did not start. Status: \(String(describing: status))")
        }
    }

    @IBAction func tripDidStop(_ sender: Any) {
        self.turnOnStart()

        let sdk = SENTSDK.sharedInstance()!
        sdk.stopTrip({
            print("SDK external trip did stop")
        }) { (issue) in
            self.turnOnStop()
            print("SDK external trip did not stop. Status: \(String(describing: issue))")
        }
    }

    func turnOnStart() {
        DispatchQueue.main.async {
            self.tripDidStartLabel.isEnabled = true;
            self.tripDidStartLabel.backgroundColor = self.redColor

            self.tripDidStopLabel.isEnabled = false;
            self.tripDidStopLabel.backgroundColor = self.greyColor
        }
    }

    func turnOnStop() {
        DispatchQueue.main.async {
            self.tripDidStartLabel.isEnabled = false;
            self.tripDidStartLabel.backgroundColor = self.greyColor

            self.tripDidStopLabel.isEnabled = true;
            self.tripDidStopLabel.backgroundColor = self.redColor
        }
    }

}

