//
//  ViewController.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 27/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var viewModel = WordQuizViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.tableFooterView = UIView()
        
        tableView.register(cellType: WordsTableViewCell.self)
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

}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.words?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeeReusableCell(with: WordsTableViewCell.self, for: indexPath)
        
        cell.word = viewModel.words?[indexPath.row] ?? "--"
        
        return cell
    }
}

// MARK: - View Model Delegate
extension ViewController: WordQuizViewModelDelegate {
    func isLoading(isLoading: Bool) {
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
}
