//
//  AppearViewController.swift
//  LimitingProgram
//
//  Created by lu on 16/8/23.
//  Copyright © 2016年 Cribug. All rights reserved.
//

import UIKit

class AppearViewController: UIViewController {

    @IBOutlet weak var exitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AppearViewController {
    
    
    @IBAction func clickToExit() {
        //        let appDelegate = AppDelegate()
        let alert = UIAlertController.init(title: "⚠️Warning", message: "The program will be exit", preferredStyle: UIAlertControllerStyle.Alert)
        let confirmAction = UIAlertAction.init(title: "confirm", style: UIAlertActionStyle.Destructive, handler: { (confirmAct) in
            self.exitApplication()
        })
        alert.addAction(confirmAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
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
}
