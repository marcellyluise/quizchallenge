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
        
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObservers()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupTableView()
        updateCounterAndTimerViewModel()
        setupTextField()
    }
    // MARK: Table View
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(cellType: WordsTableViewCell.self)
    }
    
    // MARK: TextField
    private func setupTextField() {
        inputTextField.rounded(with: 4.0)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        paddingView.backgroundColor = .clear
        
        inputTextField.leftView = paddingView
        inputTextField.leftViewMode = .always
    }
    
    // MARK: UI Components
    private func showHiddenComponents() {
        
        UIView.animate(withDuration: 0.3) {
            self.inputTextField.isHidden = false
        }
    }
    
    private func updateCounterAndTimerViewModel() {
        let counterTimerViewModel = CounterAndTimerViewModel(numberOfExpectedWords: viewModel.expectedNumberOfWords,
                                                             numberOfTypedWords: viewModel.numberOfWordsTyped)
        counterAndTimerView.viewModel = counterTimerViewModel
    }

    // MARK: - Features
    @IBAction func addAnswer(_ sender: UITextField) {
    
        guard let word = sender.text else {
            return
        }
        
        addAnswer(with: word)
    }
    
    // MARK: Add answer
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
    
    // MARK: Alert Completed Quiz
    private func showSuccessMessage() {
        showAlert(with: "Congratulations", message: "Good job! You found all the answers on time. Keep up with the great work", actionTitle: "Play again", actionStyle: .cancel) { (action) in
            
            DispatchQueue.main.async {
                self.playAgain()
            }
            
        }
    }
    // MARK: Alert Did Not Finish Quiz
    private func showDidNotFinishMessage() {
        showAlert(with: "Time finished", message: "Sorry, time is up! You got \(viewModel.numberOfWordsTyped) out of \(viewModel.expectedNumberOfWords) answers.", actionTitle: "Try again", actionStyle: .cancel) { (action) in
            
            DispatchQueue.main.async {
                self.playAgain()
            }
        }
    }
    
    // MARK: - Timer
    @objc private func timerDidFinish() {
        viewModel.timerDidFinish()
    }
    
    @objc private func userDidResetTimer() {
        viewModel.userDidResetTimer()
        cleanInput()
    }
    
    private func pauseTimer() {
        NotificationCenter.default.post(name: .pauseTimer, object: nil)
    }
    
    private func startTimer() {
        NotificationCenter.default.post(name: .startTimer, object: nil)
    }
    
    // MARK: - Counter
    private func updateWordsCounter() {
        updateCounterAndTimerViewModel()
    }
    
    
    // MARK: - Input
    private func cleanInput() {
        self.inputTextField.text = nil
    }
    
}

// MARK: - Observers

extension WordQuizController {
    // MARK: Add Observes
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(timerDidFinish), name: .timerDidFinish, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidResetTimer), name: .userDidResetTimer, object: nil)
    }
    
    // MARK: Remove Observes
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .timerDidFinish, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userDidResetTimer, object: nil)
    }
}

// MARK: Keyboard
extension WordQuizController {
    
    // MARK: Will Show
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.pushViewUp(with: keyboardSize)
        }
    }

    // MARK: Will Hide
    @objc func keyboardWillHide(notification: NSNotification) {
        pullViewDown()
    }
    
    // MARK: Push View Up
    private func pushViewUp(with keyboardSize: CGRect) {
        UIView.animate(withDuration: 0.3) {
            
            let currentiPhoneModel = UIDevice.current.name
            
            if currentiPhoneModel.contains("iPhone X") || currentiPhoneModel.contains("iPhone 11") {
                
                let safeArea: CGFloat = 34.0
                let keyboardHeight: CGFloat = keyboardSize.height
                
                self.bottomConstraint.constant = (keyboardHeight - safeArea) * (-1)
            } else {
                let counterTimerHeight: CGFloat = self.counterAndTimerView.frame.height
                
                let safeArea: CGFloat = 34.0
                let keyboardHeight: CGFloat = keyboardSize.origin.y
                
                self.bottomConstraint.constant = (keyboardHeight - safeArea - counterTimerHeight) * (-1)
            }
        }
    }
    
    // MARK: Pull View Down
    private func pullViewDown() {
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
        return viewModel.numberOfWordsTyped
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return generateWordCell(with: tableView, at: indexPath)
    }
    
    // MARK: Generate Cells
    private func generateWordCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeeReusableCell(with: WordsTableViewCell.self, for: indexPath)
        
        cell.word = viewModel.typedWords[indexPath.row]
        
        return cell
    }
}

// MARK: - View Model

extension WordQuizController: WordQuizViewModelDelegate {
    
    // MARK: Setup
    private func setupViewModel() {
        viewModel = WordQuizViewModel(delegate: self)
    }
    
    // MARK: - Delegates
    
    func isLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.view.lockView(with: 0.2)
            } else {
                self.questionLabel.text = self.viewModel.question
                self.showHiddenComponents()
                self.view.unlockView(with: 0.3)
            }
        }
    }
    
    func serviceDidFail(with error: ServiceError) {
        DispatchQueue.main.async {
            self.showAlert(with: error)
        }
    }
    
    // MARK: Timer
    func shouldResetTimer() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateCounterAndTimerViewModel()
            NotificationCenter.default.post(name: .resetTimer, object: nil)
        }
    }
    
    func shouldStartTimer() {
        startTimer()
    }
    
    func shouldPauseTimer() {
        pauseTimer()
    }
    
    // MARK: Words Counter
    func shouldUpdateWordsCounter() {
        updateWordsCounter()
    }
    
    // MARK: Quiz State
    func didCompleteQuizOnTime() {
        pauseTimer()
        showSuccessMessage()
    }
    
    func didNotFinishQuiz() {
        showDidNotFinishMessage()
    }
    
    @objc func userDidResetQuiz() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateCounterAndTimerViewModel()
        }

    }
}

// MARK: - Input Delegate
extension WordQuizController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addAnswer(with: textField.text)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.cleanInput()
        }
        
        return true
    }
}
