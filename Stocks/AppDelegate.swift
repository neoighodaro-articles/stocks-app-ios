//
//  AppDelegate.swift
//  Stocks
//
//  Created by Neo Ighodaro on 03/09/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let pushNotifications = PushNotifications.shared


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        pushNotifications.start(instanceId: AppConstants.BEAMS_INSTANCE_ID)
        pushNotifications.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pushNotifications.registerDeviceToken(deviceToken)
    }
}

