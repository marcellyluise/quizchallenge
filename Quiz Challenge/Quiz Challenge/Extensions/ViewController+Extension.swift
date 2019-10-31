//
//  ViewController+Extension.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 29/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

typealias AlertActionHandler = (UIAlertAction) -> Void

extension UIViewController {
    
    func showAlert(with title: String?, message: String?, actionTitle: String?, actionStyle: UIAlertAction.Style, and actionHandler: @escaping AlertActionHandler) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: actionHandler)
        
        alertController.addAction(action)
        
        show(alertController, sender: self)
        
    }
    
    func showAlert(with error: ServiceError) {
        switch error {
        case .emptyData, .endpointInvalid:
            showAlert(with: "Ops!", message: "We got no data. Please, try later", actionTitle: "Ok")
        case .errorMessage(let message):
            showAlert(with: "Erro", message: message, actionTitle: "Ok")
            
        case .errorStatusCode(let statusCode):
            showAlert(with: "Ops!", message: "We got a \(statusCode) and we are dealing with it. Sorry", actionTitle: "Alright")
            
        case .unknown:
            showAlert(with: "Oh no!", message: "Something happen and we are working on it", actionTitle: "Ok dokey")
        }
    }
    
    private func showAlert(with title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, actioStyle: UIAlertAction.Style = .default, actionTitle: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let okAction = UIAlertAction(title: actionTitle, style: actioStyle, handler: nil)
        
        alertController.addAction(okAction)
        
        show(alertController, sender: self)
    }
}
