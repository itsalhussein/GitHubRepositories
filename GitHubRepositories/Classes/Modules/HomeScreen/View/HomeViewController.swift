//
//  HomeViewController.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let viewModel: HomeViewModel
    private let bag = DisposeBag()

    // MARK: - Initilization
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        title = "Repositories"
        setupTableView()
        bindInputs()
        bindOutputs()
    }
    
    // MARK: - UI Configurations
    private 
    func setupTableView(){
        tableView.separatorStyle = .none
        tableView.register(RepositoryCell.nib, forCellReuseIdentifier: RepositoryCell.identifier)
    }
    
    // MARK: - Binding
    private 
    func bindInputs(){
        viewModel.input.viewDidLoad.onNext(())
        
        tableView.rx.modelSelected(RepositoryCellViewModel.self)
            .subscribe(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                guard let id = viewModel.model?.id else { return }
                let viewController = RepositoryDetailsViewController(viewModel: RepositoryDetailsViewModel(id: id))
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: bag)
    }
    
    private 
    func bindOutputs(){
        viewModel.output
            .repositories
            .drive(tableView.rx.items(cellIdentifier: RepositoryCell.identifier, cellType: RepositoryCell.self)) { index, cellViewModel, cell in
                cell.viewModel = cellViewModel
            }
            .disposed(by: bag)
    }
}
