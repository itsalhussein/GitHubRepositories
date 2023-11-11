//
//  RepositoryCellViewModel.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

class RepositoryCellViewModel {
    //MARK: - Properites
    let model: Repository?
    //MARK: - Init
    init(model: Repository?) {
        self.model = model
    }
}


