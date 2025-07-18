//
//  UserDetailView.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoadingDetails {
                ProgressView()
            } else {
                userDetailsHeaderView
            }
            
            if viewModel.isLoadingRepos {
                ProgressView()
            } else {
                repoListView
            }
            
            Spacer()
        }
        .task {
            viewModel.fetchUserDetails()
            viewModel.fetchUserRepos()
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var userDetailsHeaderView: some View {
        VStack(spacing: 8) {
            if let avatarURL = viewModel.userDetails?.avatarURL,
               let url = URL(string: avatarURL),
               !avatarURL.isEmpty {
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                    @unknown default:
                        EmptyView()
                    }
                }

            } else {
                // Fallback if URL is nil or invalid
                Image(systemName: "person.crop.circle.badge.xmark")
                    .resizable()
                    .frame(width: 90, height: 80)
                    .foregroundColor(.gray)
            }
        
            Text("\(viewModel.userDetails?.login ?? "N/A")")
                .font(.headline)
            Text("\(viewModel.userDetails?.bio ?? "")")
            
            HStack {
                HStack(alignment: .bottom, spacing: 1) {
                    Text("Followers: ").bold()
                    if let followersCount = viewModel.userDetails?.followers {
                        Text("\(followersCount)")
                    } else {
                        Text("--")
                    }
                }
                
                Spacer()
                
                HStack(alignment: .bottom, spacing: 1) {
                    Text("Public repositories: ").bold()
                    if let reposCount = viewModel.userDetails?.publicRepos {
                        Text("\(reposCount)")
                    } else {
                        Text("--")
                    }
                }
            }
        }
        .padding(16)
    }
    
    var repoListView: some View {
        List {
            if let error = viewModel.reposError, viewModel.userRepos.isEmpty {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.blue)
                    Text("\(error)")
                }
            } else {
                ForEach(viewModel.userRepos, id: \.id) { repo in
                    RepositoryRowView(repo: repo)
                }
            }
        }
    }
}

#Preview {
    UserDetailView(viewModel: UserDetailViewModel(user: GitHubUser(login: "naveen-colab", id: 71389724, nodeID: "MDQ6VXNlcjcxMzg5NzI0", avatarURL: "https://avatars.githubusercontent.com/u/71389724?v=4", gravatarID: "", url: "https://api.github.com/users/naveen-colab", htmlURL: "https://github.com/naveen-colab", followersURL: "https://api.github.com/users/naveen-colab/followers", followingURL: "https://api.github.com/users/naveen-colab/following{/other_user}", gistsURL: "https://api.github.com/users/naveen-colab/gists{/gist_id}", starredURL: "https://api.github.com/users/naveen-colab/starred{/owner}{/repo}", subscriptionsURL: "https://api.github.com/users/naveen-colab/subscriptions", organizationsURL: "https://api.github.com/users/naveen-colab/orgs", reposURL: "https://api.github.com/users/roshini/repos", eventsURL: "https://api.github.com/users/naveen-colab/events{/privacy}", receivedEventsURL: "https://api.github.com/users/naveen-colab/received_events", type: "User", userViewType: "public", siteAdmin: false, score: 1.0)))
}

struct RepositoryRowView: View {
    let repo: GitHubRepository

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Repo Name
            Text(repo.name)
                .font(.headline)

            // Repo Description
            Text(repo.description ?? "No description")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)

            // Stars and Forks Row
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Image(systemName: "star")
                    Text("\(repo.stargazersCount)")
                        .font(.caption)
                }

                HStack(spacing: 4) {
                    Image(systemName: "tuningfork") // or "arrow.branch"
                    Text("\(repo.forksCount)")
                        .font(.caption)
                }
            }
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
