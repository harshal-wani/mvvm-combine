//
//  APIService.swift
//  WordGame
//
//  Created by Harshal Wani on 27/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import Combine

///API Error mapping
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

    static func parseDecodingError(_ error: DecodingError) -> String {
        var errorToReport = error.localizedDescription
        switch error {
        case .dataCorrupted(let context):
            let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }
                .joined(separator: ".")
            errorToReport = "\(context.debugDescription) - (\(details))"
        case .keyNotFound(let key, let context):
            let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }
                .joined(separator: ".")
            errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
        case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
            let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }
                .joined(separator: ".")
            errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
        @unknown default:
            break
        }
        return errorToReport
    }
}

protocol APIServiceProtocol {
    func fetch<T: Decodable>(_ endPoint: EndPoint) -> AnyPublisher<T, APIError>
}

final class APIService: APIServiceProtocol {

    func fetch<T: Decodable>(_ endPoint: EndPoint) -> AnyPublisher<T, APIError> {
        fetch(endPoint)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let err = error as? DecodingError {
                    return APIError(rawValue: APIError.parseDecodingError(err))!
                } else {
                    return APIError.unknownError
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private
    private func fetch(_ endPoint: EndPoint) -> AnyPublisher<Data, APIError> {

        guard let url = endPoint.url else {
            return Fail(error: .invalidURL)
                .eraseToAnyPublisher()
        }
        /// Check is internet available
        if !Utilities.isInternetAvailable() {
            return Fail(error: .noNetwork)
                .eraseToAnyPublisher()
        }
        /// Set URLRequest and type
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let data = endPoint.data {
            request.httpBody = data
        }

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw (APIError.checkErrorCode((response as? HTTPURLResponse)!.statusCode))
                }
                return data
        }
        .mapError { error in
            if let error = error as? APIError {
                return error
            } else {
                return .unknownError
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
