//
//  Words.swift
//  WordGame
//
//  Created by Harshal Wani on 27/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import Combine

struct Word: Decodable {
    let langOneWord, langTwoWord: String

    enum CodingKeys: String, CodingKey {
      case langOneWord = "text_eng"
      case langTwoWord = "text_spa"
    }
}
