//
//  ViewController.swift
//  Trivia
//
//  Created by Ollie Elmgren on 6/28/20.
//  Copyright © 2020 Ollie Elmgren. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import HTMLString
import DropDown

struct SettingsObject {
  var amount = 1
  var difficulty = ""
  var category = ""
  var textCategory = "Any Category"
}

struct JeopardySettingsObject {
  // 105
  var value = ""
  var category = ""
  var categoryText  = "Any Category"
  var difficulty = ""
}

var Settings = SettingsObject()
var JeopardySettings = JeopardySettingsObject()

class ViewController: UIViewController {
  @IBOutlet weak var triviaLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var answerButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
  var currTrivia = Trivia()
  var amount_input = 1
  
  @IBAction func answerButtonTapped(_ sender: Any) {
    answerLabel.text = currTrivia.answer
  }
  
  @IBAction func nextButtonTapped(_ sender: Any) {
    getJeopardy()
  }
  
  func setLabels() {
    triviaLabel.text = currTrivia.question
    answerLabel.text = ""
  }
  
  func setValue () {
    switch JeopardySettings.difficulty {
    case "":
      JeopardySettings.value = ""
    case "easy":
      JeopardySettings.value = ["100","200","300"].randomElement()!
    case "medium":
      JeopardySettings.value = ["400","500","600"].randomElement()!
    case "hard":
      JeopardySettings.value = ["700","800","900","1000"].randomElement()!
    default:
      break
    }
  }
  
  func getJeopardy () {
    setValue()
    var url = "https://jservice.io/api/clues"
    let parameters: [String: String] = ["category": JeopardySettings.category, "value": JeopardySettings.value]
    AF.request(url, parameters: parameters).responseJSON { response in
      switch response.result {
      case .success(let value):
          if let allObjects = value as? NSArray{
               print("Array length is \(allObjects.count)")
          }
          let json = JSON(value)
          print("JSON: \(json)")
          let element = json.randomElement()?.1
          print("ELEMENT: \(element)")
          let question = element?["question"].string
          let correct_answer = element?["answer"].string
          let value = element?["value"].string
          // Don't like the which questions now
          if(question == "" || correct_answer == "" || correct_answer == nil) {
            self.getJeopardy()
          }
          self.currTrivia.answer = correct_answer!.removingHTMLEntities
          self.currTrivia.question = question!.removingHTMLEntities
          if(value != nil) {
            self.currTrivia.difficulty = value!
          } else {
            self.currTrivia.difficulty = "500"
          }
//          self.currTrivia.difficulty = difficulty!
//          self.currTrivia.category = category!
          self.setLabels()
          
      case .failure(let error):
          print(error)
      }
    }
  }
  
  func getTrivia() {
    let url = "https://opentdb.com/api.php"
    let parameters: [String: String] = ["amount": "1","difficulty" : Settings.difficulty, "type" : "multiple", "category": Settings.category]
    AF.request(url, parameters: parameters).responseJSON { response in
      switch response.result {
      case .success(let value):
          let json = JSON(value)
          print("JSON: \(json)")
          let question = json["results"][0]["question"].string
          let correct_answer = json["results"][0]["correct_answer"].string
          let difficulty = json["results"][0]["difficulty"].string
          let category = json["results"][0]["category"].string
          // Don't like the which questions now
          if (question!.contains("which") || question!.contains("Which")) {
            self.getTrivia()
            break
          }
          self.currTrivia.answer = correct_answer!.removingHTMLEntities
          self.currTrivia.question = question!.removingHTMLEntities
          self.currTrivia.difficulty = difficulty!
          self.currTrivia.category = category!
          self.setLabels()
          
      case .failure(let error):
          print(error)
      }
    }
   }
  
  func styleViewController () {
    answerButton.layer.cornerRadius = 5
    nextButton.layer.cornerRadius = 5
    settingsButton.layer.cornerRadius = 5
    settingsButton.contentMode = .scaleToFill
    answerButton.contentMode = .center
    nextButton.contentMode = .center
  }
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    getJeopardy ()
    print(triviaLabel.text)
    styleViewController()
  }
}

class SettingsViewController: UIViewController {
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var dropDownView: UIView!
  @IBOutlet weak var easyButton: UIButton!
  @IBOutlet weak var mediumButton: UIButton!
  @IBOutlet weak var hardButton: UIButton!
  @IBOutlet weak var anyButton: UIButton!
  
  @IBAction func exitButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func styleSettings () {
    easyButton.layer.cornerRadius = 5
    anyButton.layer.cornerRadius = 5
    hardButton.layer.cornerRadius = 5
    mediumButton.layer.cornerRadius = 5
    dropDownView.layer.cornerRadius = 5
    dropDownView.backgroundColor = UIColor.systemTeal
    DropDown.appearance().selectedTextColor = UIColor.white
    DropDown.appearance().selectionBackgroundColor = UIColor.systemYellow
    DropDown.appearance().textFont = UIFont(name: "Avenir Next", size: 17) ?? UIFont.systemFont(ofSize: 15)
  }
  
  let categories = ["Any Category" : "",
  "Miscellaneous": "306",
  "Sports": "42",
  "American History" : "780",
  "3 Letter Words" : "105",
  "Science" : "25",
  "U.S. Cities" : "7",
  "TV" : "67",
  "State Capitals" : "109",
  "History" : "114",
  "Bible": "31",
  "Geography" : "582",
  "Business" : "176",
  "Food and Drink" : "253",
  "Rhyme" : "561",
  "Bodies of Water" : "211",
  "Word Origins" : "223",
  "Alcohol (Potent Potables)" : "83",
  "World History" : "530",
  "Colleges & Universities" : "672",
  "Mythology" : "680",
  "Quotes" : "1420",
  "Around the World" : "1079",
  "U.S. States" : "17",
  "Brand Names" : "2537",
  "Phrases" : "705"
  ]
  
  let menu: DropDown = {
    let menu = DropDown()
    menu.dataSource = ["Any Category",
                        "Miscellaneous",
                        "Sports",
                        "American History",
                        "3 Letter Words",
                        "Science",
                        "U.S. Cities",
                        "TV",
                        "State Capitals",
                        "History",
                        "Bible",
                        "Geography",
                        "Business",
                        "Food and Drink",
                        "Rhyme",
                        "Bodies of Water",
                        "Word Origins",
                        "Alcohol (Potent Potables)",
                        "World History",
                        "Colleges & Universities",
                        "Mythology",
                        "Quotes",
                        "Around the World",
                        "U.S. States",
                        "Brand Names",
                        "Phrases"
    ]
    menu.dataSource.sort()
    return menu
  }()
  
  @IBAction func anyButtonTapped(_ sender: Any) {
    anyButton.backgroundColor = UIColor.purple
    easyButton.backgroundColor = UIColor.systemYellow
    mediumButton.backgroundColor = UIColor.systemYellow
    hardButton.backgroundColor = UIColor.systemYellow
    JeopardySettings.difficulty = ""
  }
  
  @IBAction func easyButtonTapped(_ sender: Any) {
    easyButton.backgroundColor = UIColor.purple
    mediumButton.backgroundColor = UIColor.systemYellow
    hardButton.backgroundColor = UIColor.systemYellow
    anyButton.backgroundColor = UIColor.systemYellow
    JeopardySettings.difficulty = "easy"
  }
  
  @IBAction func mediumButtonTapped(_ sender: Any) {
    mediumButton.backgroundColor = UIColor.purple
    easyButton.backgroundColor = UIColor.systemYellow
    hardButton.backgroundColor = UIColor.systemYellow
    anyButton.backgroundColor = UIColor.systemYellow
    JeopardySettings.difficulty = "medium"
  }
  
  @IBAction func hardButtonTapped(_ sender: Any) {
    hardButton.backgroundColor = UIColor.purple
    easyButton.backgroundColor = UIColor.systemYellow
    mediumButton.backgroundColor = UIColor.systemYellow
    anyButton.backgroundColor = UIColor.systemYellow
    JeopardySettings.difficulty = "hard"
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    styleSettings ()
    categoryLabel.text = JeopardySettings.categoryText
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapDropDown))
    gesture.numberOfTapsRequired = 1
    gesture.numberOfTouchesRequired = 1
    dropDownView.addGestureRecognizer(gesture)
    menu.anchorView = dropDownView
    menu.selectionAction = { index, title in
      print("index \(index) title \(title)")
      JeopardySettings.category = self.categories[title]!
      JeopardySettings.categoryText = title
      self.categoryLabel.text = title
    }
    if(Settings.difficulty == "") {
      anyButton.backgroundColor = UIColor.purple
    }
    if(Settings.difficulty == "easy") {
      easyButton.backgroundColor = UIColor.purple
    }
    if(Settings.difficulty == "medium") {
      mediumButton.backgroundColor = UIColor.purple
    }
    if(Settings.difficulty == "hard") {
      hardButton.backgroundColor = UIColor.purple
    }
  }
  
  @objc func didTapDropDown() {
    menu.show()
  }
}

