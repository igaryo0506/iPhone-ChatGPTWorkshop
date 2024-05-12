//
//  ViewController.swift
//  ChatGPTWorkshop1
//
//  Created by 五十嵐諒 on 2024/05/10.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var resultLabels: [UILabel]!
    private var resultsNum: Int = 0
    
    var client: OpenAIClient?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultsNum = resultLabels.count
        client = .init(apiKey: Configuration.openAIAPIKey)
    }

    @IBAction func search() {
        guard let text = textField.text else { return }
        client?.fetchSynonyms(for: text) { words in
            if let words {
                for index in 0..<self.resultsNum {
                    DispatchQueue.main.async {
                        self.resultLabels[index].text = words[index]
                    }
                }
            }
        }
    }
}

