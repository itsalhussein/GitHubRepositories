//
//  RepositoryDetailsViewModel.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class RepositoryDetailsViewModel{
   
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
        let repositoryDetails: Driver<Repository?>
    }
    
    // MARK: - Output Private properties
    private let repositoryDetailsSubject =  PublishSubject<Repository?>()
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    private let id : Int
    internal var networkManager : NetworkManagerProtocol

    // MARK: - Init
    init(id: Int) {
        self.id = id
        self.networkManager = NetworkManager.shared
        // MARK: inputs observers
        input = .init(
            viewDidLoad: viewDidLoadSubject.asObserver()
        )
        
        // MARK: Otuput observers
        output = .init(
            repositoryDetails: repositoryDetailsSubject.asDriver(onErrorJustReturn: nil)
        )
        
        viewDidLoadSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                Task {
                    do {
                        try await self.fetchRepositoryDetails(id: self.id)
                    } catch {
                        print("fetchData Error: \(error)")
                    }
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Methods
    private
    func fetchRepositoryDetails(id: Int) async throws {
        do {
            let detailedRepository = try await self.networkManager.fetchRepositoryDetails(id: id)
            print("detailedRepository : \(detailedRepository)")
            repositoryDetailsSubject.onNext(detailedRepository)
        } catch {
            print("fetchRepositories Error: \(error)")
        }
    }
    
}
