//
//  Storyboarded.swift
//  WordGame
//
//  Created by Harshal Wani on 26/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit

protocol Storyboarded {
   static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {

    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
        // swiftlint:enable force_cast
    }
}
