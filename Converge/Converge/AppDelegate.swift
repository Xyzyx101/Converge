//
//  AppDelegate.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-06-22.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        Audio.instance().musicOff()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        Audio.instance().musicOn()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        Audio.instance().playMusic()
    }

    func applicationWillTerminate(application: UIApplication) {
        SKTAudio.sharedInstance().backgroundMusicPlayer?.stop()
        SKTAudio.sharedInstance().soundEffectPlayer?.stop()
    }
}

