//
//  ScreenViewController.swift
//  TennisBusiness
//
//  Created by user on 6/7/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class ScreenViewController: UIViewController {
    func presentViewController(withIdentifier identifier: String, storyboardIdentifier: String? = nil) {
        let storyboard = UIStoryboard(name: storyboardIdentifier ?? identifier, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        present(controller, animated: true, completion: nil)
    }
}
