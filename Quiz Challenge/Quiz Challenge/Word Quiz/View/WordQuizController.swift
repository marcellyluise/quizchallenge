//
//  WordQuizController.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 27/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

class WordQuizController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var wordCounterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    
    var viewModel: WordQuizViewModel!
    
    var timer = Timer()
    let fiveMin: TimeInterval = 5 * 60 * 60 * 60
    var fiveMinutes: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WordQuizViewModel(delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.tableFooterView = UIView()
        
        tableView.register(cellType: WordsTableViewCell.self)
        
    }

    @IBAction func startReset(_ sender: Any) {
        
        if timer.isValid {
            resetTimer()
        } else {
            startTimer()
        }
    }
    
    @IBAction func addAnswer(_ sender: UITextField) {
        
        guard let word = sender.text else {
            return
        }
        
        viewModel.addAnswer(with: word)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func startTimer() {
        fiveMinutes = fiveMin
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
        timer.fire()
    }
  
    private func resetTimer() {
        DispatchQueue.main.async {
            self.timerLabel.text = "5:00"
            self.fiveMinutes = self.fiveMin
            self.timer.invalidate()
        }
    }
    
    @objc private func updateCountdown() {
        DispatchQueue.main.async {
            self.fiveMinutes -= 1
            self.timerLabel.text = "\(self.fiveMinutes)"
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint.constant = keyboardSize.height + 100
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = 0
        }

    }
    
    private func addAnswer(with word: String?) {
        viewModel.addAnswer(with: word)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension WordQuizController: UITableViewDelegate {

}

extension WordQuizController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeeReusableCell(with: WordsTableViewCell.self, for: indexPath)
        
        cell.word = viewModel.answers[indexPath.row]
        
        return cell
    }
}

// MARK: - View Model Delegate
extension WordQuizController: WordQuizViewModelDelegate {
    func isLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            self.questionLabel.text = self.viewModel.question
            self.tableView.reloadData()
        }
    }
}

// MARK: Input

extension WordQuizController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addAnswer(with: textField.text)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.inputTextField.text = nil
            self.wordCounterLabel.text = "\(self.viewModel.counter)/\(self.viewModel.words?.count ?? 0)"
        }
        
        return true
    }
    
}

