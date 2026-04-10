import SwiftUI

/// 热门视频列表
/// 对应 Flutter: lib/pages/hot/view.dart
struct HotView: View {
    @State private var viewModel = HotViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                HotContentView(items: items, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView(
                    "加载失败",
                    systemImage: "exclamationmark.triangle",
                    description: Text(msg ?? "未知错误")
                )
            }
        }
        .navigationTitle("热门")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}

// MARK: - 热门内容
private struct HotContentView: View {
    let items: [RecVideoItem]
    let viewModel: HotViewModel

    var body: some View {
        List {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                VideoHotRowView(rank: index + 1, item: item)
                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - 热门视频行
private struct VideoHotRowView: View {
    let rank: Int
    let item: RecVideoItem

    var body: some View {
        NavigationLink(value: Route.videoDetail(.fromRecVideo(item))) {
            HStack(spacing: 10) {
                // 排名
                Text("\(rank)")
                    .font(.title3.bold())
                    .foregroundStyle(rank <= 3 ? .orange : .secondary)
                    .frame(width: 30)

                // 封面
                AsyncImage(url: URL(string: item.pic ?? "")) { img in
                    img.resizable().aspectRatio(16/9, contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(.fill.secondary)
                }
                .frame(width: 120, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 6))

                // 标题
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.subheadline)
                        .lineLimit(2)
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.caption2)
                        Text(item.stat?.view.shortFormatted ?? "")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}
