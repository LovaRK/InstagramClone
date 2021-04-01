//
//  SceneDelegate.swift
//  InstagramClone
//
//  Created by Lova Krishna on 18/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Photos

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        FirebaseApp.configure()
        self.setupNavBar()
        self.setupTabbar()
       
            self.showRootViewController {
                AVCaptureDevice.authorizeVideo(completion: { (status) in
                    print("AVCaptureDevice Value ++++==++++++",status)
                })
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({status in
                        print("PHPhotoLibrary Value ++++==++++++",status)
                    })
                }
            }
    }
        
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    fileprivate func setupNavBar() {
        UINavigationBar.appearance().barTintColor = UIColor.init(hex: "#00BFFF")
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
    }
    
    fileprivate func setupTabbar() {
        UITabBar.appearance().barTintColor = UIColor.init(hex: "#00BFFF")
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
    }
    
    func showRootViewController( completion: (() -> Void)? = nil) {
        let user = Auth.auth().currentUser;
        if user != nil {
            self.loadHome()
            completion?()
        }else{
            self.loadLoging()
            completion?()
        }
    }
    
    fileprivate func loadHome() {
        let vc = TabBarController()
       // let nc = setupNavigationBar(vc: vc)
        window?.switchRootViewController(vc, animated: true)
        window?.makeKeyAndVisible()
        
    }
    
    fileprivate func loadLoging() {
        let vc = SignInVC()
        let nc = UINavigationController.init(rootViewController: vc)
        window?.switchRootViewController(nc, animated: true)
        self.window?.makeKeyAndVisible()
    }
    
}

