//
//  Words.swift
//  WordGame
//
//  Created by Harshal Wani on 27/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation

struct Word: Decodable {
    let langOneWord, langTwoWord: String
    let isTranslationCorrect: AnswerAction

    enum CodingKeys: String, CodingKey {
      case langOneWord = "text_eng"
      case langTwoWord = "text_spa"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        langOneWord = try container.decode(String.self, forKey: .langOneWord)
        langTwoWord = try container.decode(String.self, forKey: .langTwoWord)

        //IMPORTANT: Set is translation true/false randomly
        isTranslationCorrect = (Bool.random() == true) ? .correct : .wrong
    }
}
