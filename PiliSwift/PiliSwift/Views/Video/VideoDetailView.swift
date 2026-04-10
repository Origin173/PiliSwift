import SwiftUI
import AVKit

/// 视频详情页
/// 对应 Flutter: lib/pages/video/view.dart (VideoDetailPage)
struct VideoDetailView: View {
    let params: VideoDetailParams
    @State private var viewModel: VideoDetailViewModel

    init(params: VideoDetailParams) {
        self.params = params
        _viewModel = State(initialValue: VideoDetailViewModel(params: params))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                VStack {
                    Rectangle()
                        .fill(.black)
                        .aspectRatio(16/9, contentMode: .fit)
                        .overlay(ProgressView().tint(.white))
                    Spacer()
                }
            case .success(let detail):
                VideoDetailContentView(detail: detail, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView(
                    "加载失败",
                    systemImage: "exclamationmark.triangle",
                    description: Text(msg ?? "未知错误")
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .task { await viewModel.load() }
    }
}

// MARK: - 视频详情内容
private struct VideoDetailContentView: View {
    let detail: VideoDetail
    let viewModel: VideoDetailViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                // 播放器占位
                VideoPlayerPlaceholder(viewModel: viewModel)

                // 视频信息区
                VideoInfoSection(detail: detail, viewModel: viewModel)

                Divider()

                // 相关视频
                RelatedVideosSection(viewModel: viewModel)
            }
        }
    }
}

// MARK: - 播放器占位区
private struct VideoPlayerPlaceholder: View {
    let viewModel: VideoDetailViewModel

    var body: some View {
        ZStack {
            Color.black
                .aspectRatio(16/9, contentMode: .fit)

            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .aspectRatio(16/9, contentMode: .fit)
            } else {
                ProgressView().tint(.white)
            }
        }
    }
}

// MARK: - 视频信息节
private struct VideoInfoSection: View {
    let detail: VideoDetail
    let viewModel: VideoDetailViewModel
    @Environment(Router.self) private var router

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 标题
            Text(detail.title)
                .font(.headline)
                .lineLimit(3)

            // 统计信息
            HStack(spacing: 16) {
                Label(detail.stat?.view.shortFormatted ?? "", systemImage: "play.fill")
                Label(detail.stat?.danmaku.shortFormatted ?? "", systemImage: "text.bubble.fill")
                Label(detail.stat?.like.shortFormatted ?? "", systemImage: "hand.thumbsup.fill")
                Spacer()
                Text(detail.pubdateFormatted)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            // UP 主按钮
            if let owner = detail.owner {
                Button {
                    router.push(.member(mid: owner.mid))
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: owner.face)) { img in
                            img.resizable()
                        } placeholder: {
                            Circle().fill(.fill.secondary)
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())

                        Text(owner.name)
                            .font(.subheadline.bold())
                        Spacer()

                        Button("关注") {
                            Task { await viewModel.toggleFollow(mid: owner.mid) }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
                .buttonStyle(.plain)
            }

            // 操作按钮行
            VideoActionBar(viewModel: viewModel)

            // 简介展开
            if let desc = detail.desc, !desc.isEmpty {
                Text(desc)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(viewModel.descExpanded ? nil : 2)
                    .onTapGesture { viewModel.descExpanded.toggle() }
            }
        }
        .padding()
    }
}

// MARK: - 视频操作栏
private struct VideoActionBar: View {
    let viewModel: VideoDetailViewModel

    var body: some View {
        HStack(spacing: 0) {
            // 点赞
            VideoActionButton(
                icon: "hand.thumbsup",
                activeIcon: "hand.thumbsup.fill",
                label: viewModel.likeCount,
                isActive: viewModel.hasLiked
            ) { Task { await viewModel.toggleLike() } }

            Spacer()

            // 投币
            VideoActionButton(
                icon: "bitcoinsign.circle",
                activeIcon: "bitcoinsign.circle.fill",
                label: "投币",
                isActive: viewModel.hasCoined
            ) { Task { await viewModel.coin() } }

            Spacer()

            // 收藏
            VideoActionButton(
                icon: "star",
                activeIcon: "star.fill",
                label: viewModel.favCount,
                isActive: viewModel.hasFaved
            ) { Task { await viewModel.toggleFav() } }

            Spacer()

            // 分享
            VideoActionButton(
                icon: "square.and.arrow.up",
                activeIcon: "square.and.arrow.up",
                label: "分享",
                isActive: false
            ) { viewModel.share() }

            Spacer()

            // 弹幕开关
            VideoActionButton(
                icon: "text.bubble",
                activeIcon: "text.bubble.fill",
                label: "弹幕",
                isActive: viewModel.danmakuOn
            ) { viewModel.danmakuOn.toggle() }
        }
    }
}

// MARK: - 操作按钮组件
private struct VideoActionButton: View {
    let icon: String
    let activeIcon: String
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isActive ? activeIcon : icon)
                    .font(.title3)
                    .foregroundStyle(isActive ? .accentColor : .secondary)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 相关视频节
private struct RelatedVideosSection: View {
    let viewModel: VideoDetailViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("相关视频")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)

            LazyVStack(spacing: 0) {
                ForEach(viewModel.relatedVideos) { item in
                    VideoCardView(item: item)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
        }
    }
}

// MARK: - VideoDetail 扩展
extension VideoDetail {
    var pubdateFormatted: String {
        guard let pubdate else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(pubdate))
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .none
        return fmt.string(from: date)
    }
}
