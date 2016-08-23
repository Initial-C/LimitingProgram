//
//  AppDelegate.swift
//  LimitingProgram
//
//  Created by lu on 16/8/23.
//  Copyright © 2016年 Cribug. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var vc : AppearViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        let nav = UINavigationController.init(rootViewController: AppearViewController())
        self.window?.rootViewController = nav
//        self.window?.rootViewController = AppearViewController()
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func applicationDidBecomeActive(application: UIApplication) {
        // 限制登录
        let endDate = "2016-09-10 00:00:00"
        //        let minuteInterval = timeIntervalUnit(endDate).0
        //        let dayInterval = timeIntervalUnit(endDate).1
        //        print("分钟间隔:", minuteInterval)
        //        print("天数间隔:", dayInterval)
        //        print("日期间隔:", timeIntervalToEndTime(endDate))
        print("时间间隔:", timeIntervalForSeconds(endDate))
        let secondsToMinutes = timeIntervalForSeconds(endDate)
        if secondsToMinutes > 2.0 && secondsToMinutes <= 2880 {  // 项目剩余可用时间为两天内开始提醒
            let alert = UIAlertController.init(title: "温馨提示", message: "项目服务到期还有:\(timeIntervalToEndTime(endDate)), 请及时续费", preferredStyle: UIAlertControllerStyle.Alert)
            let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Destructive, handler:nil)
            alert.addAction(confirmAction)
            self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
        }else if secondsToMinutes <= 2.0 {
            let alert = UIAlertController.init(title: "温馨提示", message: "项目服务到期, 请续费", preferredStyle: UIAlertControllerStyle.Alert)
            let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (confirmAct) in
                self.exitApplication()
            })
            alert.addAction(confirmAction)
            self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
        } else if secondsToMinutes > 2880 {
            //            print("网络时间======:\(secondsToMinutes)")
            if secondsToMinutes == 25920.0 {
                let alert = UIAlertController.init(title: "温馨提示", message: "请连接网络, 再重启程序", preferredStyle: UIAlertControllerStyle.Alert)
                let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (confirmAct) in
                    self.vc?.view
                    self.exitApplication()
                })
                alert.addAction(confirmAction)
                self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
            }
            // 获取本机时间
            var date:NSDate = NSDate()
            // 设置系统时区为本地时区
            let zone:NSTimeZone = NSTimeZone.systemTimeZone()
            // 计算本地时区与 GMT 时区的时间差
            let second:Int = zone.secondsFromGMT
            // 在 GMT 时间基础上追加时间差值，拿到本地时间
            date = date.dateByAddingTimeInterval(NSTimeInterval(second))
            //            print("本机当前时间:", date)
        }
        
    }
    // MARK:-退出程序
    func exitApplication() {
        let appDelegate = UIApplication.sharedApplication().delegate
        let windows = appDelegate?.window
        windows!!.backgroundColor = UIColor.whiteColor()
        windows!!.alpha = 0.8
        UIView.animateWithDuration(0.8, animations: {
            windows!!.alpha = 0
            windows!!.frame = CGRectMake(UIScreen.mainScreen().bounds.width * 0.5, UIScreen.mainScreen().bounds.height * 0.5, 0, 0)
        }) { (bool) in
            exit(0)
        }
    }
    // MARK:- 计算日期间隔
    func timeIntervalUnit(endDate : String) -> (Int, Int){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowTime = NSDate()
        let endTime = formatter.dateFromString(endDate)
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        let duringDates = calendar?.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: nowTime, toDate: endTime!, options: NSCalendarOptions.init(rawValue: 0))
        return ((duringDates?.minute)!,(duringDates?.day)!)
    }
    // MARK:- 计算时间间隔
    func timeIntervalToEndTime(endDate : String) -> (String){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowTime = NSDate()
        let endTime = formatter.dateFromString(endDate)
        let dateComponentsFormatter = NSDateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        let interval = endTime!.timeIntervalSinceDate(nowTime)
        return dateComponentsFormatter.stringFromTimeInterval(interval)!
    }
    // MARK:- 时间间隔精确到秒
    func timeIntervalForSeconds(endDate : String) -> (Double){
        let dateInternet = GetInternetTime()
        var internetTime = dateInternet.getInternetDate()
        //        let internetTime = dateInternet.getInternetDateOtherMethod()
        // TODO: 拿到网络时间设置为参考时间
        if internetTime == nil {
            let format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let nilStr = "2016-08-22 16:00:00"
            let netDt : NSDate = format.dateFromString(nilStr)!
            internetTime = netDt
        }
        // 设置系统时区为本地时区
        let zone:NSTimeZone = NSTimeZone.systemTimeZone()
        // 计算本地时区与 GMT 时区的时间差
        let second:Int = zone.secondsFromGMT
        // 在 GMT 时间基础上追加时间差值，拿到本地时间
        let timeFromInternet = internetTime.dateByAddingTimeInterval(NSTimeInterval(second))
        
        // 时间格式化
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let endTime = formatter.dateFromString(endDate)
        // 计算时间差
        let timeInterval = endTime!.timeIntervalSinceDate(timeFromInternet)
        let minuteTime = timeInterval / 60.0
        let minuteTimeStr = String(format: "%.1f", minuteTime)
        let finalMinuteTime = Double(minuteTimeStr)
        return finalMinuteTime!
    }

}

