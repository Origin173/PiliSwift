import SwiftUI

// MARK: - 关注列表
/// 对应 Flutter: lib/pages/follow/view.dart
struct FollowView: View {
    let mid: Int64
    @State private var viewModel: FollowViewModel

    init(mid: Int64) {
        self.mid = mid
        _viewModel = State(initialValue: FollowViewModel(mid: mid))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                UserList(items: items, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "person.2.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("关注")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}

// MARK: - 粉丝列表
struct FanView: View {
    let mid: Int64
    @State private var viewModel: FanViewModel

    init(mid: Int64) {
        self.mid = mid
        _viewModel = State(initialValue: FanViewModel(mid: mid))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                UserList(items: items, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "person.2.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("粉丝")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
}

// MARK: - 用户列表组件（关注/粉丝均用）
private struct UserList<VM: UserListViewModel>: View {
    let items: [FollowItem]
    let viewModel: VM

    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(value: Route.member(mid: item.mid)) {
                    UserRow(item: item)
                }
            }
            Color.clear.frame(height: 1)
                .onAppear { Task { await viewModel.loadMore() } }
        }
        .listStyle(.plain)
    }
}

// MARK: - 用户行组件
private struct UserRow: View {
    let item: FollowItem

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.face)) { img in
                img.resizable()
            } placeholder: {
                Circle().fill(.fill.secondary)
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(item.uname)
                    .font(.subheadline.bold())
                if let sign = item.sign, !sign.isEmpty {
                    Text(sign)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 关注搜索
struct FollowSearchView: View {
    let mid: Int64
    @State private var query = ""

    var body: some View {
        VStack {
            TextField("搜索关注", text: $query)
                .textFieldStyle(.roundedBorder)
                .padding()
            Text("搜索 UID \(mid) 的关注列表")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .navigationTitle("搜索关注")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 协议占位（供 UserList 在关注/粉丝两处复用）
protocol UserListViewModel: Observable {
    func loadMore() async
}
