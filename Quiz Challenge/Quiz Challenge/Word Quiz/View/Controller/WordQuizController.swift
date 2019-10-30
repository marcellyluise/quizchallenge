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
        counterAndTimerView.delegate = self
        counterAndTimerView.dataSource = self

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

}

// MARK: - Keyboard

extension WordQuizController {
    
    // MARK: Observers
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    // MARK: Setup
    private func setupViewModel() {
        viewModel = WordQuizViewModel(delegate: self)
    }
    
    // MARK: Delegate
    func isLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            self.questionLabel.text = self.viewModel.question
            self.counterAndTimerView.reloadCounterAndTimerData()
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
            self.counterAndTimerView.reloadCounterAndTimerData()
            self.inputTextField.text = nil
        }
        
        return true
    }
    
}

// MARK: - Words Counter and Timer View

extension WordQuizController: CounterAndTimerDataSource {

    // MARK: Data Source
    func numberOfTypedWords() -> Int {
        return viewModel.numberOfWordsTyped
    }
    
    func totalOfWords() -> Int {
        return viewModel.expectedNumberOfWords
    }
    
    func shouldStartTimer() -> Bool {
        return viewModel.userDidBeginToType
    }
    
    
}

// MARK: Delegate
extension WordQuizController: CounterAndTimerViewDelegate {
    func timerDidEnd() {
        
    }
    
    
    func didTapStartTimer() {
        
    }
    
    func didTapResetTimer() {
        
    }
    
}
