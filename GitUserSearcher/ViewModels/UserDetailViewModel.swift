//
//  UserDetailViewModel.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import Foundation

final class UserDetailViewModel: ObservableObject {
    
    let user: GitHubUser
    
    @Published var userRepos: [GitHubRepository] = []
    
    @Published var isLoadingRepos: Bool = false
    
    @Published var isLoadingDetails: Bool = false
    
    @Published var detailsError: String? = nil
    
    @Published var reposError: String? = nil
    
    @Published var userDetails: GitHubUserDetail? = nil
    
    init(user: GitHubUser) {
        self.user = user
    }
    
    func fetchUserDetails() {
        print("Feeding user details")
        isLoadingDetails = true
        
        Task { [weak self] in
            guard let url = self?.user.url else {
                self?.detailsError = "User URL not available"
                return
            }
            
            let response = await getGithubUserDetails(url: url)
            
            await MainActor.run { [weak self] in
                self?.userDetails = response
                self?.isLoadingDetails = false
            }
        }
    }
    
    
    func fetchUserRepos() {
        print("Fetching user repos")
        isLoadingRepos = true
        Task { [weak self] in
            guard let reposURL = self?.user.reposURL, let username = self?.user.login else {
                self?.reposError = "Username is not available"
                return
            }
            let response = await getGithubUserRepositories(username: username, perPage: 100, page: 1)
            
            self?.updateUserRepos(response)
        }
    }
    
    func updateUserRepos(_ repos: [GitHubRepository]?) {
        Task { @MainActor in
            if let repos = repos {
                if repos.isEmpty {
                    reposError = "User has zero repositories"
                }
                userRepos = repos
            } else {
                reposError = "No repositories found"
            }
            isLoadingRepos = false
        }
    }
}


