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
}
