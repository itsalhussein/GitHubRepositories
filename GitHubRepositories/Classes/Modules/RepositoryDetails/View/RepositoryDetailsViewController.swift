//
//  RepositoryDetailsViewController.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!

    //MARK: - Properties
    private let viewModel: RepositoryDetailsViewModel
    private let bag = DisposeBag()

    // MARK: - Initilization
    init(viewModel: RepositoryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInputs()
        bindOutputs()
    }
    
    // MARK: - Binding
    private 
    func bindInputs(){
        viewModel.input.viewDidLoad.onNext(())
    }
    
    private 
    func bindOutputs(){
        viewModel.output.repositoryDetails
            .drive(onNext: { [weak self] repositoryDetails in
                guard let self = self else { return }
                if let name = repositoryDetails?.name {
                    self.nameLabel.text = name
                }
                
                if let fullName = repositoryDetails?.full_name {
                    self.fullNameLabel.text = fullName
                }
                
                if let description = repositoryDetails?.description {
                    self.discriptionLabel.text = description
                }
                
                if let createdAt = repositoryDetails?.created_at {
                    self.createdAtLabel.text = createdAt.formatDate()
                }
                
                if let imageUrl = repositoryDetails?.owner?.avatar_url {
                    ImageCache.shared.loadImage(with: imageUrl) {[weak self] image in
                        // Update UI on the main thread
                        DispatchQueue.main.async {
                            self?.repoImageView.image = image
                        }
                    }
                }
                
                if let forkCount = repositoryDetails?.forks_count {
                    self.forkCountLabel.text = "\(forkCount)"
                }
                
                if let starsCount = repositoryDetails?.stargazers_count {
                    self.starsCountLabel.text = "\(starsCount)"
                }
                
                if let watchersCount = repositoryDetails?.watchers_count {
                    self.watchCountLabel.text = "\(watchersCount)"
                }
            })
            .disposed(by: bag)
    }
}
