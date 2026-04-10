import SwiftUI

// MARK: - 收藏夹列表
/// 对应 Flutter: lib/pages/fav/view.dart
struct FavView: View {
    let mid: Int64
    @State private var viewModel: FavViewModel

    init(mid: Int64) {
        self.mid = mid
        _viewModel = State(initialValue: FavViewModel(mid: mid))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let folders):
                List(folders) { folder in
                    NavigationLink(value: Route.favDetail(id: folder.id ?? 0, title: folder.title ?? "")) {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: folder.cover ?? "")) { img in
                                img.resizable().aspectRatio(1, contentMode: .fill)
                            } placeholder: {
                                Rectangle().fill(.fill.secondary)
                            }
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 6))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(folder.title ?? "")
                                    .font(.subheadline)
                                Text("\(folder.mediaCount ?? 0) 个收藏")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "star.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("收藏夹")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
}

// MARK: - 收藏夹详情（视频列表）
struct FavDetailView: View {
    let mediaId: Int64
    let title: String
    @State private var viewModel: FavDetailViewModel

    init(mediaId: Int64, title: String) {
        self.mediaId = mediaId
        self.title = title
        _viewModel = State(initialValue: FavDetailViewModel(mediaId: mediaId))
    }

    private let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(items) { item in VideoCardView(item: item) }
                    }
                    .padding(8)

                    Color.clear.frame(height: 1)
                        .onAppear { Task { await viewModel.loadMore() } }
                }
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "exclamationmark.triangle",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}
