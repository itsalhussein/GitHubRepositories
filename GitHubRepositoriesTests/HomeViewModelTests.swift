//
//  HomeViewModelTests.swift
//  GitHubRepositoriesTests
//
//  Created by Hussein Anwar on 11/11/2023.
//

import XCTest
import RxSwift
import RxCocoa

@testable import GitHubRepositories

final class HomeViewModelTests: XCTestCase {

    func testFetchRepositories() async {
        let viewModel = HomeViewModel()
        viewModel.networkManager = MockNetworkManager()
        
        do {
            try await viewModel.fetchRepositories()
            XCTAssertEqual(viewModel.repositoriesCount, 2)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testConfigureRepositoriesCells() async {
        let viewModel = HomeViewModel()
        viewModel.networkManager = MockNetworkManager()
        
        do {
            try await viewModel.fetchRepositories()
            await viewModel.configureRepositoriesCells([Repository(id: 0,
                                                                   name: "Repo2",
                                                                   full_name: "repoFullName2",
                                                                   description: "desc",
                                                                   owner: Repository.Owner.init(login: "lign", id: 0, avatar_url: "avatar_url"),
                                                                   created_at: "createAt",
                                                                   stargazers_count: 15,
                                                                   watchers_count: 25,
                                                                   forks_count: 2
                                                 )])
            XCTAssertEqual(viewModel.repositoriesCount, 1)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}


class MockNetworkManager: NetworkManagerProtocol {
    
    var shouldThrowError: Bool = false
    
    func fetchRepositoryList() async throws -> [Repository] {
        if shouldThrowError {
            throw NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        } else {
            //some dummy repositories for testing
            return [Repository(id: 0,
                               name: "Repo1",
                               full_name: "repoFullName1",
                               description: "desc",
                               owner: Repository.Owner.init(login: "lign", id: 0, avatar_url: "avatar_url"),
                               created_at: "createAt",
                               stargazers_count: 15,
                               watchers_count: 25,
                               forks_count: 2
                              ),
                    Repository(id: 0,
                               name: "Repo2",
                               full_name: "repoFullName2",
                               description: "desc",
                               owner: Repository.Owner.init(login: "lign", id: 0, avatar_url: "avatar_url"),
                               created_at: "createAt",
                               stargazers_count: 15,
                               watchers_count: 25,
                               forks_count: 2
                              )]
        }
    }
    
    func fetchRepositoryDetails(id: Int) async throws -> GitHubRepositories.Repository {
        return Repository(id: 0,
                          name: "Repo2",
                          full_name: "repoFullName2",
                          description: "desc",
                          owner: Repository.Owner.init(login: "lign", id: 0, avatar_url: "avatar_url"),
                          created_at: "createAt",
                          stargazers_count: 15,
                          watchers_count: 25,
                          forks_count: 2
        )
    }
}
