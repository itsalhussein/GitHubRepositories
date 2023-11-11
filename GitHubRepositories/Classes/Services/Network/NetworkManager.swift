//
//  NetworkManager.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchRepositoryList() async throws -> [Repository]
    func fetchRepositoryDetails(id: Int) async throws -> Repository
}

class NetworkManager : NetworkManagerProtocol {
    
    static let shared = NetworkManager()

    private let apiBaseUrl = "https://api.github.com"
    private init() {}

    func fetchRepositoryList() async throws -> [Repository] {
        let listUrl = URL(string: "\(apiBaseUrl)/repositories")!
        let (data, _) = try await URLSession.shared.data(from: listUrl)
        let jsonString = String(data: data, encoding: .utf8)
        print("JSON Response: \(jsonString ?? "Unable to convert data to string")")
        return try JSONDecoder().decode([Repository].self, from: data)
    }

    func fetchRepositoryDetails(id: Int) async throws -> Repository {
        let detailsUrl = URL(string: "\(apiBaseUrl)/repositories/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: detailsUrl)
        return try JSONDecoder().decode(Repository.self, from: data)
    }
}

