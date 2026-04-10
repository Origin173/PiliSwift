import SwiftUI

/// 首页推荐视频流
/// 对应 Flutter: lib/pages/home/view.dart
struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                HomeContentView(items: items, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView(
                    "加载失败",
                    systemImage: "exclamationmark.triangle",
                    description: Text(msg ?? "未知错误")
                )
            }
        }
        .navigationTitle("首页")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.loadInitial() }
        .refreshable { await viewModel.refresh() }
    }
}

// MARK: - 推荐流内容
private struct HomeContentView: View {
    let items: [RecVideoItem]
    let viewModel: HomeViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(items) { item in
                    VideoCardView(item: item)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)

            // 触底加载更多
            Color.clear
                .frame(height: 1)
                .onAppear {
                    Task { await viewModel.loadMore() }
                }
        }
    }
}
