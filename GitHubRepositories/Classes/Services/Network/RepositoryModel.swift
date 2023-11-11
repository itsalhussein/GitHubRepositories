//
//  RepositoryModel.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import Foundation

struct Repository: Codable {
    let id: Int?
    let name: String?
    let full_name: String?
    let description: String?
    let owner: Owner?
    let created_at: String?
    let stargazers_count: Int?
    let watchers_count: Int?
    let forks_count: Int?
    
    struct Owner: Codable {
        let login: String?
        let id: Int?
        let avatar_url: String?
    }
}
