//
//  HomeViewModel.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa


class HomeViewModel{
   
    // MARK: - Inputs
    let input: Input
    
    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }
    
    // MARK: - Input Private properties
    private let viewDidLoadSubject =  PublishSubject<Void>()

    // MARK: - Outputs
    let output: Output
    
    struct Output {
        let repositories: Driver<[RepositoryCellViewModel]>
    }
    
    // MARK: - Output Private properties
    internal let repositoriesSubject =  PublishSubject<[RepositoryCellViewModel]>()
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    internal var networkManager : NetworkManagerProtocol
    //For Unit Testing Purposes
    internal var repositoriesCount = 0
    
    // MARK: - Init
    init() {
        self.networkManager = NetworkManager.shared
        
        // MARK: inputs observers
        input = .init(
            viewDidLoad: viewDidLoadSubject.asObserver()
        )
        
        // MARK: Otuput observers
        output = .init(
            repositories: repositoriesSubject.asDriver(onErrorJustReturn: [])
        )
        
        viewDidLoadSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                Task {
                    do {
                        try await self.fetchRepositories()
                    } catch {
                        print("fetchData Error: \(error)")
                    }
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Methods
    internal
    func fetchRepositories() async throws {
        do {
            let repositories = try await self.networkManager.fetchRepositoryList()
            await self.configureRepositoriesCells(repositories)
        } catch {
            print("fetchRepositories Error: \(error)")
        }
    }
    
    internal
    func configureRepositoriesCells(_ repos: [Repository]) async {
        let cellViewModels = repos.map { model -> RepositoryCellViewModel  in
            return .init(model: model)
        }
        //For Unit Testing Purposes
        repositoriesCount = repos.count
        repositoriesSubject.onNext(cellViewModels)
    }
 
}
