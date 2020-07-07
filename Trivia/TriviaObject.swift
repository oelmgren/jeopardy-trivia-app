//
//  TriviaObject.swift
//  Trivia
//
//  Created by Ollie Elmgren on 6/28/20.
//  Copyright © 2020 Ollie Elmgren. All rights reserved.
//

import Foundation
import UIKit

class Trivia {
    var question: String
    var answer : String
    var category: String
    var difficulty: String
    
    init() {
        self.question = ""
        self.answer = ""
        self.category = ""
        self.difficulty = ""
    }
}

