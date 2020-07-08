//
//  AbstractViewModel.swift
//  WordGame
//
//  Created by Harshal Wani on 29/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation

class AbstractViewModel {

    let apiService: APIServiceProtocol

    init() {
        // For live API services
        self.apiService = APIService()

        //For Mock API services
//        self.apiService = MockAPIService()
    }
}
