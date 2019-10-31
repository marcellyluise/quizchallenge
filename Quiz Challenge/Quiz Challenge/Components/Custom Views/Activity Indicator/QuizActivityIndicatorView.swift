//
//  QuizActivityIndicatorView.swift
//  Quiz Challenge
//
//  Created by INDRA BRASIL SOLUCOES E SERVICOS TECNOLOGICOS on 30/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

class QuizActivityIndicatorView: XibLoader {
    
    @IBOutlet private weak var roundedGrayBackgroundView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func shouldStartActivityIndicator(start: Bool) {
        start ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    override func didLoadViewFromXib() {
        roundedGrayBackgroundView.rounded(with: 24.0)
        backgroundColor = UIColor.white.withAlphaComponent(0.75)
        activityIndicator.hidesWhenStopped = true
    
        tag = 42
    }
}
