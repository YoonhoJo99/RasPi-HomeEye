//
//  SceneDelegate.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // 첫화면이 뜨기전에, 탭바를 내장시키기⭐️⭐️⭐️
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 화면을 구성하는 객체를 만들어 window에 할당.. 몰라도 된다.
        window = UIWindow(windowScene: windowScene)

        // 탭바컨트롤러의 생성
        let tabBarVC = UITabBarController()
        
        // 첫번째 화면은 네비게이션컨트롤러로 만들기 (기본루트뷰 설정)
        let vc1 = UINavigationController(rootViewController: EnvironmentMonitorViewController())
        let vc2 = LiveStreamViewController()
        let vc3 = EventGalleryViewController()


        // 탭바 이름들 설정
        vc1.title = "Environment"
        vc2.title = "Live Stream"
        vc3.title = "Gallery"
        
        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        
        // 탭바 이미지 설정 (이미지는 애플이 제공하는 것으로 사용)
        guard let items = tabBarVC.tabBar.items else { return }
        
        // Environment 탭: 온도/습도 관련 아이콘
        items[0].image = UIImage(systemName: "thermometer.medium")
        items[0].selectedImage = UIImage(systemName: "thermometer.medium.fill")

        // Live Stream 탭: 비디오/카메라 관련 아이콘
        items[1].image = UIImage(systemName: "video")
        items[1].selectedImage = UIImage(systemName: "video.fill")

        // Gallery 탭: 사진/갤러리 관련 아이콘
        items[2].image = UIImage(systemName: "photo.on.rectangle")
        items[2].selectedImage = UIImage(systemName: "photo.on.rectangle.fill")

            
        // 전 강의에서는 present했음. 여기서는 아님 -> window속성에 가장 기본이 되는 Cotroller를 tabBar컨트롤러로 넣어줌
        
        // 기본루트뷰를 탭바컨트롤러로 설정⭐️⭐️⭐️
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible() // 몰라도 됨. 우리가 코드로 UI를 만들 때 사용하는 코드. 외우지 마!
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

