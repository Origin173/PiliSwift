import SwiftUI

// MARK: - 直播入口
/// 对应 Flutter: lib/pages/live/view.dart
struct LiveView: View {
    @State private var viewModel = LiveViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                LiveRoomGrid(items: items, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "antenna.radiowaves.left.and.right.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("直播")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}

private struct LiveRoomGrid: View {
    let items: [LiveRoomItem]
    let viewModel: LiveViewModel
    private let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(items) { item in
                    NavigationLink(value: Route.liveRoom(roomId: item.roomId)) {
                        LiveRoomCard(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
        }
    }
}

private struct LiveRoomCard: View {
    let item: LiveRoomItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: item.cover ?? "")) { img in
                img.resizable().aspectRatio(16/9, contentMode: .fill)
            } placeholder: {
                Rectangle().fill(.fill.secondary)
            }
            .aspectRatio(16/9, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(alignment: .topTrailing) {
                Text("直播中")
                    .font(.caption2.bold())
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(4)
            }

            Text(item.title ?? "")
                .font(.subheadline)
                .lineLimit(2)
            Text(item.uname ?? "")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - 直播间页
struct LiveRoomView: View {
    let roomId: Int64
    @State private var viewModel: LiveRoomViewModel

    init(roomId: Int64) {
        self.roomId = roomId
        _viewModel = State(initialValue: LiveRoomViewModel(roomId: roomId))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success:
                LiveRoomContent(viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("直播间不可用", systemImage: "tv.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .task { await viewModel.load() }
    }
}

private struct LiveRoomContent: View {
    let viewModel: LiveRoomViewModel

    var body: some View {
        VStack(spacing: 0) {
            // 播放区域占位
            Color.black
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(
                    Text("直播画面")
                        .foregroundStyle(.white.opacity(0.5))
                )

            // 弹幕区域
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(viewModel.danmakus) { dm in
                        Text(dm.content)
                            .font(.caption)
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

// MARK: - 直播分区
struct LiveAreaView: View {
    var body: some View {
        Text("直播分区")
            .navigationTitle("直播分区")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 排行榜
struct RankView: View {
    @State private var viewModel = RankViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                List(Array(items.prefix(100).enumerated()), id: \.offset) { idx, item in
                    NavigationLink(value: Route.videoDetail(.fromRecVideo(item))) {
                        VideoRowView(item: item)
                    }
                }
                .listStyle(.plain)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "chart.bar.xaxis",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("排行榜")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
}
