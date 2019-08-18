//
//  AppConfig+Snapshot.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/7/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import FirebaseFirestore

extension AppConfig {
    init(snapshots: [QueryDocumentSnapshot]) {
        var general: GeneralConfig?
        if let generalDocument = snapshots.first(where: { $0.documentID == "general" }),
            generalDocument.exists,
            let moderatorDevices = generalDocument.data()["moderatorDevices"] as? [String] {
            general = GeneralConfig(moderatorDevices: moderatorDevices)
        }
        self.init(general: general)
    }
}
