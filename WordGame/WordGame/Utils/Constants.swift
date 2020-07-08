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

/// Error
enum APIError: String, Error {
    case invalidURL             = "Invalid url"
    case invalidResponse        = "Invalid response"
    case decodeError            = "Decode error"
    case pageNotFound           = "Requested page not found!"
    case noData                 = "Oops! No words found."
    case noNetwork              = "Internet connection not available!"
    case unknownError           = "Unknown error"
    case serverError            = "Server not found, operation could't not be completed!"

    static func checkErrorCode(_ errorCode: Int = 0) -> APIError {
        switch errorCode {
        case 400:
            return .invalidURL
        case 500:
            return .serverError
        case 404:
            return .pageNotFound
        default:
            return .unknownError
        }
    }
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
