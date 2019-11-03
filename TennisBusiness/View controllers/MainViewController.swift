//
//  MainViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MainViewController: ScreenViewController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConfig()
    }
    
    
    
    // MARK: - Private
    
    private func loadConfig() {
        database.collection("config").getDocuments { [weak self] (configSnapshot, error) in
            guard let documents = configSnapshot?.documents,
                error == nil else {
                    return
            }
            let appConfig = AppConfig(snapshots: documents)
            if let currentDeviceId = DeviceInfo.deviceId, appConfig.general?.moderatorDevices.contains(currentDeviceId) ?? false {
                self?.presentViewController(withIdentifier: "ModeratorMain", fromNavigation: true)
                UIApplication.shared.isIdleTimerDisabled = true
            }
            else {
                self?.presentViewController(withIdentifier: "UserMain")
            }
        }
    }
}

