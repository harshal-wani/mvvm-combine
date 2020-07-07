//
//  MockAPIService.swift
//  WordGame
//
//  Created by Harshal Wani on 29/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import Combine

final class MockAPIService: APIServiceProtocol {

    func getDataFromURL(_ endPoint: EndPoint) -> AnyPublisher<Data, APIError> {

        return Future<Data, APIError> { promise in

            let url = Bundle.main.url(forResource: "words", withExtension: "json")!
            do {
                let data = try Data(contentsOf: url)
                promise(.success(data))
            } catch {
                promise(.failure(APIError.decodeError))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
