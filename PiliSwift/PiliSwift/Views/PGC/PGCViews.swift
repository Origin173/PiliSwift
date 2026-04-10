import SwiftUI

// MARK: - 番剧/PGC 详情页
/// 对应 Flutter: lib/pages/pgc/view.dart
struct PGCView: View {
    let seasonId: Int64
    @State private var viewModel: PGCViewModel

    init(seasonId: Int64) {
        self.seasonId = seasonId
        _viewModel = State(initialValue: PGCViewModel(seasonId: seasonId))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let season):
                PGCContentView(season: season, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "tv.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .task { await viewModel.load() }
    }
}

private struct PGCContentView: View {
    let season: PGCSeason
    let viewModel: PGCViewModel
    @Environment(Router.self) private var router

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 封面
                AsyncImage(url: URL(string: season.cover ?? "")) { img in
                    img.resizable()
                        .aspectRatio(3/4, contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(.fill.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .clipped()

                VStack(alignment: .leading, spacing: 12) {
                    Text(season.title ?? "")
                        .font(.title2.bold())

                    Text(season.evaluate ?? "")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    // 剧集列表
                    Text("剧集")
                        .font(.headline)

                    LazyVStack(spacing: 4) {
                        ForEach(season.episodes ?? []) { ep in
                            Button {
                                router.push(.videoDetail(VideoDetailParams(
                                    bvid: ep.bvid ?? "",
                                    epId: ep.id
                                )))
                            } label: {
                                HStack {
                                    Text(ep.longTitle ?? ep.title ?? "第\(ep.index ?? 0)集")
                                        .font(.subheadline)
                                    Spacer()
                                    Image(systemName: "play.circle")
                                        .foregroundStyle(Color.accentColor)
                                }
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                            Divider()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - 番剧索引页
struct PGCIndexView: View {
    var body: some View {
        Text("番剧索引")
            .navigationTitle("番剧索引")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 我的追番/追剧
struct SubscriptionView: View {
    @State private var viewModel = SubscriptionViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let seasons):
                List(seasons) { season in
                    NavigationLink(value: Route.pgc(seasonId: season.seasonId ?? 0)) {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: season.cover ?? "")) { img in
                                img.resizable().aspectRatio(3/4, contentMode: .fill)
                            } placeholder: {
                                Rectangle().fill(.fill.secondary)
                            }
                            .frame(width: 50, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 6))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(season.title ?? "")
                                    .font(.subheadline)
                                Text(season.newDesc ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "heart.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("我的追番")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}

// MARK: - 番剧追番详情
struct SubscriptionDetailView: View {
    let seasonId: Int64
    var body: some View {
        PGCView(seasonId: seasonId)
    }
}

// MARK: - 番剧评分页
struct PGCReviewView: View {
    let seasonId: Int64
    var body: some View {
        Text("用户评分 (\(seasonId))")
            .navigationTitle("用户评价")
            .navigationBarTitleDisplayMode(.inline)
    }
}
