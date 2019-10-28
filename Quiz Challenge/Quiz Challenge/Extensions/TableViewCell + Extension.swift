//
//  TableViewCell + Extension.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 27/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

protocol NibIdentifiable: class {
    static var nib: UINib { get }
}

extension NibIdentifiable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

protocol ClassIdentifiable: class {
    static var reuseId: String { get }
}

extension ClassIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}

typealias CellIdentifieable = NibIdentifiable & ClassIdentifiable

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) where T: CellIdentifieable {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseId)
    }
    
    func dequeeReusableCell<T: UITableViewCell>(with cellType: T.Type = T.self, for indexPath: IndexPath) -> T where T: CellIdentifieable {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseId, for: indexPath) as? T else {
            fatalError("Something wrong happend when trying to dequee UITableViewCell with identifier: \(cellType.reuseId)")
        }
        
        return cell
    }
}
