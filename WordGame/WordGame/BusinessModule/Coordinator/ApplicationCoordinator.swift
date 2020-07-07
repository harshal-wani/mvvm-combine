//
//  ApplicationCoordinator.swift
//  WordGame
//
//  Created by Harshal Wani on 26/12/19.
//  Copyright © 2019 Harshal Wani. All rights reserved.
//

import UIKit

final class ApplicationCoordinator: Coordinator {

    private let window: UIWindow
    private let rootViewController: UINavigationController
    private var dashboardCoordinator: DashboardCoordinator?

    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.barStyle = .black
        dashboardCoordinator = DashboardCoordinator(presenter: rootViewController)
    }

    func start() {
        window.rootViewController = rootViewController
        dashboardCoordinator?.start()
        window.makeKeyAndVisible()
    }

}
