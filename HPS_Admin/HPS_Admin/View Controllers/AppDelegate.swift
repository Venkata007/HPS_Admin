//
//  AppDelegate.swift
//  HPS_Admin
//
//  Created by Vamsi on 04/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import SwiftyJSON
import EZSwiftExtensions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                TheGlobalPoolManager.instanceIDTokenMessage  = result.token
            }
        }
        self.SetInitialViewController()
        if let tabBarController = window?.rootViewController as? TabBarController {
            tabBarController.selectedIndex = 1
            DispatchQueue.main.async {
                if let unselectedImage = UIImage(named: "Events_deactive"), let selectedImage = UIImage(named: "Events_active") {
                    tabBarController.addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage)
                }
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

}
extension AppDelegate{
    func automaticallyLoginAfterSignUp(){
        let storyBoard : UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: ViewControllerIDs.TabBarController) as! TabBarController
        controller.selectedIndex = 1
        self.window?.rootViewController = controller
    }
    func SetInitialViewController(){
        if UserDefaults.standard.value(forKey:ADMIN_USER_INFO) != nil{
            let dic = TheGlobalPoolManager.retrieveFromDefaultsFor(ADMIN_USER_INFO) as! NSDictionary
            let userDetails = JSON(dic)
            ModelClassManager.adminLoginModel = AdminLoginModel.init(fromJson: userDetails)
            TheGlobalPoolManager.selectedUserType = ADMIN
            self.automaticallyLoginAfterSignUp()
        }else if UserDefaults.standard.value(forKey:TADMIN_USER_INFO) != nil{
            let dic = TheGlobalPoolManager.retrieveFromDefaultsFor(TADMIN_USER_INFO) as! NSDictionary
            let userDetails = JSON(dic)
            ModelClassManager.tAdminLoginModel = TAdminLoginModel.init(fromJson: userDetails)
            TheGlobalPoolManager.selectedUserType = TABLE_ADMIN
            self.automaticallyLoginAfterSignUp()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller : UINavigationController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationID") as! UINavigationController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
    }
}

