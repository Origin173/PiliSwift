import SwiftUI

// MARK: - 历史记录
/// 对应 Flutter: lib/pages/history/view.dart
struct HistoryView: View {
    @State private var viewModel = HistoryViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                HistoryList(items: items, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "clock.badge.xmark",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("历史记录")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}

private struct HistoryList: View {
    let items: [RecVideoItem]
    let viewModel: HistoryViewModel

    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(value: Route.videoDetail(.fromRecVideo(item))) {
                    VideoRowView(item: item)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task { await viewModel.delete(item: item) }
                    } label: {
                        Label("删除", systemImage: "trash")
                    }
                }
            }
            Color.clear.frame(height: 1)
                .onAppear { Task { await viewModel.loadMore() } }
        }
        .listStyle(.plain)
    }
}

// MARK: - 稍后再看
/// 对应 Flutter: lib/pages/later/view.dart
struct LaterView: View {
    @State private var viewModel = LaterViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                LaterList(items: items, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "bookmark.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("稍后再看")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}

private struct LaterList: View {
    let items: [RecVideoItem]
    let viewModel: LaterViewModel

    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(value: Route.videoDetail(.fromRecVideo(item))) {
                    VideoRowView(item: item)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task { await viewModel.delete(item: item) }
                    } label: {
                        Label("删除", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - 共用视频行组件（列表样式）
struct VideoRowView: View {
    let item: RecVideoItem

    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: URL(string: item.pic ?? "")) { img in
                img.resizable().aspectRatio(16/9, contentMode: .fill)
            } placeholder: {
                Rectangle().fill(.fill.secondary)
            }
            .frame(width: 120, height: 68)
            .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .lineLimit(2)
                HStack {
                    Text(item.owner?.name ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if let view = item.stat?.view {
                        Label(view.shortFormatted, systemImage: "play.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
