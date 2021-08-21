//
//  SceneDelegate.swift
//  CoordinatorApp
//
//  Created by Dre on 30/07/2021.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: Coordinating?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        /*
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        */

        guard let windowScene = scene as? UIWindowScene else {
            assertionFailure()
            return
        }

        let rootVC = RootViewController()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()

        let mainFlowFactory = MainFlowFactory()
        let (mainFlowController, mainCoordinator) = mainFlowFactory.makeFlow()
        rootVC.embed(mainFlowController)
        mainCoordinator.start()
        self.appCoordinator = mainCoordinator

        // HANDLE URL
        if let urlContext = connectionOptions.urlContexts.first {
            let sendingAppID = urlContext.options.sourceApplication
            let url = urlContext.url
            print(">>> SCENE WILL CONNECT -> source application = \(sendingAppID ?? "Unknown")")
            print(">>> SCENE WILL CONNECT -> url = \(url)")
            handleURL(url, sourceApplication: sendingAppID)
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }

        let sendingAppID = urlContext.options.sourceApplication
        let url = urlContext.url
        print(">>> SCENE OPEN URL -> source application = \(sendingAppID ?? "Unknown")")
        print(">>> SCENE OPEN URL -> url = \(url)")
        handleURL(url, sourceApplication: sendingAppID)
    }

    private func handleURL(_ url: URL, sourceApplication: String?) {
        guard let deepLink = DeepLinkParser().parseURL(url: url) else {
            return
        }
        appCoordinator?.handleDeepLink(deepLink)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

}
