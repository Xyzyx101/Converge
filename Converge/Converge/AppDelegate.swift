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
        println("didFinishLoading")
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        println("resignActive")
        //SKTAudio.sharedInstance().backgroundMusicPlayer?.stop()
        //SKTAudio.sharedInstance().soundEffectPlayer?.stop()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        println("EnterBackground")
        Audio.instance().musicOff()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        println("EnterForeground")
        Audio.instance().musicOn()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        println("Active")
        Audio.instance().playMusic()
    }

    func applicationWillTerminate(application: UIApplication) {
        println("terminate")
        SKTAudio.sharedInstance().backgroundMusicPlayer?.stop()
        SKTAudio.sharedInstance().soundEffectPlayer?.stop()
    }


}

