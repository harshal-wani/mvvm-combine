//
//  Constants.swift
//  WordGame
//
//  Created by Harshal Wani on 26/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation

/// API Constants
struct BaseUrl {
    static let scheme = "https"
    static let host = "raw.githubusercontent.com"
}

/// HTTPMethod type
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct LocalizableStrings {

    /// Screen title
    static let dashboardScreenTitle = "Falling Words"

    /// Common
    static let alert = "Alert"
    static let error = "Error"
    static let ok = "Ok"
    static let cancel = "Cancel"
    static let yes = "Yes"
    static let awesome = "Awesome🤘"
    static let gameFinishedMessage = "You've completed falling word game challenge!"
    static let quitGame = "Are you sure to quit game?"

    static let oneWords = "10 Words"
    static let twoWords = "20 Words"
    static let threeWords = "30 Words"

}
