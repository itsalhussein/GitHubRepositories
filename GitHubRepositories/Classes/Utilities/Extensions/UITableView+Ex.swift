//
//  UITableView+Ex.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import UIKit

extension UITableViewCell{
    static var identifier: String {
        return String.init(describing: self)
    }
    
    static var nib: UINib {
        return UINib.init(nibName: String.init(describing: self), bundle: nil)
    }
}
