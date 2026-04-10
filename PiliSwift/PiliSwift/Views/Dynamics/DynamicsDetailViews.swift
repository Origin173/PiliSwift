import SwiftUI

// MARK: - 动态详情页
/// 对应 Flutter: lib/pages/dynamics/dyn_detail/view.dart
struct DynamicDetailView: View {
    let id: String
    @State private var viewModel: DynamicDetailViewModel

    init(id: String) {
        self.id = id
        _viewModel = State(initialValue: DynamicDetailViewModel(id: id))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let item):
                ScrollView {
                    DynamicItemDetailCard(item: item)
                        .padding()
                }
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "exclamationmark.triangle",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("动态详情")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
}

// MARK: - 动态详情卡片
private struct DynamicItemDetailCard: View {
    let item: DynamicItem
    @Environment(Router.self) private var router

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 作者
            if let author = item.modules?.moduleAuthor {
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: author.face)) { img in
                        img.resizable()
                    } placeholder: {
                        Circle().fill(.fill.secondary)
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(author.name)
                            .font(.subheadline.bold())
                        Text(author.pubTimeText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // 正文
            if let text = item.modules?.moduleDynamic?.desc?.text {
                Text(text)
                    .font(.body)
            }

            // 统计
            if let stat = item.modules?.moduleStat {
                HStack(spacing: 20) {
                    Label("\(stat.like?.count ?? 0)", systemImage: "hand.thumbsup")
                    Label("\(stat.comment?.count ?? 0)", systemImage: "text.bubble")
                    Label("\(stat.forward?.count ?? 0)", systemImage: "arrow.2.squarepath")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - 话题动态列表
struct DynamicsTopicView: View {
    let topicName: String

    var body: some View {
        Text("话题: \(topicName)")
            .navigationTitle(topicName)
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 话题推荐
struct DynTopicRcmdView: View {
    var body: some View {
        Text("热门话题")
            .navigationTitle("发现话题")
            .navigationBarTitleDisplayMode(.inline)
    }
}
