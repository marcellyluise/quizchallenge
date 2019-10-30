//
//  WordQuizController.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 27/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

class WordQuizController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var counterAndTimerView: CounterAndTimerView!
    
    var viewModel: WordQuizViewModel!
   
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupTableView()
        setupCounterAndTimerView()
    }
    

    private func setupTableView() {
        tableView.tableFooterView = UIView()
        
        tableView.register(cellType: WordsTableViewCell.self)
    }
    
    private func setupCounterAndTimerView() {
        

    }

    // MARK: - Features
    
    @IBAction func addAnswer(_ sender: UITextField) {
    
        guard let word = sender.text else {
            return
        }
        
        viewModel.addAnswer(with: word)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Add words as answer
    private func addAnswer(with word: String?) {
        viewModel.addAnswer(with: word)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Play Again
    @objc private func playAgain() {
        viewModel.playAgain()
    }
    
    // MARK: Completed Quiz
    private func showSuccessMessage() {
        showAlert(with: "Congratulations", message: "Good job! You found all the answers on time. Keep up with the great work", actionTitle: "Play again", actionStyle: .cancel) { (action) in
            self.playAgain()
        }
    }
    // MARK: Did Not Finish Quiz
    private func showDidNotFinishMessage() {
        showAlert(with: "Time finished", message: "Sorry, time is up! You got \(viewModel.numberOfWordsTyped) out of \(viewModel.expectedNumberOfWords) answers.", actionTitle: "Try again", actionStyle: .cancel) { (action) in
            self.playAgain()
        }
    }
    
    // MARK: Timer did Finish
    @objc private func timerDidFinish() {
        viewModel.timerDidFinish()
    }
    

    private func pauseTimer() {
        NotificationCenter.default.post(name: Notification.Name("PauseTimer"), object: nil)
    }
    
    private func startTimer() {
        NotificationCenter.default.post(name: Notification.Name("StartTimer"), object: nil)
    }
    
}

// MARK: - Keyboard

extension WordQuizController {
    
    // MARK: Observers
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerDidFinish), name: Notification.Name("TimerDidFinish"), object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Will Show
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.3) {
                let safeAreaHeight: CGFloat = 34.0
                self.bottomConstraint.constant = (keyboardSize.height - safeAreaHeight) * (-1)
            }
        }
    }

    // MARK: Will Hide
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = 0
        }

    }
}

// MARK: - Table View

extension WordQuizController: UITableViewDataSource {
    
    // MARK: - Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.typedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeeReusableCell(with: WordsTableViewCell.self, for: indexPath)
        
        cell.word = viewModel.typedWords[indexPath.row]
        
        return cell
    }
}

// MARK: - View Model

extension WordQuizController: WordQuizViewModelDelegate {
    func shoudResetTimer() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            NotificationCenter.default.post(name: Notification.Name("ResetTimer"), object: nil)
        }
    }
    
    func didCompleteQuizOnTime() {
        pauseTimer()
        showSuccessMessage()
    }
    
    func shouldStartTimer() {
        startTimer()
    }
    
    func shouldPauseTimer() {
        pauseTimer()
    }
    
    func didNotFinishQuiz() {
        showDidNotFinishMessage()
    }
    
    // MARK: Setup
    private func setupViewModel() {
        viewModel = WordQuizViewModel(delegate: self)
    }
    
    // MARK: Delegate
    func isLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            self.questionLabel.text = self.viewModel.question
            let counterTimerViewModel = CounterAndTimerViewModel(numberOfExpectedWords: self.viewModel.expectedNumberOfWords, numberOfTypedWords: self.viewModel.numberOfWordsTyped)
            self.counterAndTimerView.viewModel = counterTimerViewModel
            self.tableView.reloadData()
        }
    }
}

// MARK: - Input

extension WordQuizController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addAnswer(with: textField.text)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.inputTextField.text = nil
        }
        
        return true
    }
    
}
