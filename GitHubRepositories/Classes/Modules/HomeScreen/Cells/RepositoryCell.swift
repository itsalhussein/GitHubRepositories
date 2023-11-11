//
//  RepositoryCell.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class RepositoryCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoOwnerNameLabel: UILabel!
    
    //MARK: - Properties
    var viewModel: RepositoryCellViewModel! {
        didSet {
            bindUI()
        }
    }
    
    private let bag = DisposeBag()

    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.repoImageView.image = nil
    }
    
    //MARK: - Binding
    private
    func bindUI(){
        if let name = viewModel.model?.full_name {
            self.repoNameLabel.text = name
        }
        
        if let ownerName = viewModel.model?.owner?.login {
            self.repoOwnerNameLabel.text = ownerName
        }
        
        if let imageUrl = viewModel.model?.owner?.avatar_url {
            ImageCache.shared.loadImage(with: imageUrl) {[weak self] image in
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self?.repoImageView.image = image
                }
            }
        }
    }
    
}
