import SwiftUI

/// 动态页（关注的 UP 主的动态）
/// 对应 Flutter: lib/pages/dynamics/view.dart
struct DynamicsView: View {
    @State private var viewModel = DynamicsViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                DynamicsListView(items: items, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView(
                    "加载失败",
                    systemImage: "exclamationmark.triangle",
                    description: Text(msg ?? "未知错误")
                )
            }
        }
        .navigationTitle("动态")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}

// MARK: - 动态列表
private struct DynamicsListView: View {
    let items: [DynamicItem]
    let viewModel: DynamicsViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(items) { item in
                    DynamicCardView(item: item)
                        .padding(.vertical, 6)
                    Divider()
                }
                Color.clear
                    .frame(height: 1)
                    .onAppear {
                        Task { await viewModel.loadMore() }
                    }
            }
        }
    }
}

// MARK: - 动态卡片（骨架）
private struct DynamicCardView: View {
    let item: DynamicItem

    var body: some View {
        NavigationLink(value: Route.dynamicDetail(item.idStr)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    AsyncImage(url: URL(string: item.modules?.moduleAuthor?.face ?? "")) { img in
                        img.resizable()
                    } placeholder: {
                        Circle().fill(.fill.secondary)
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.modules?.moduleAuthor?.name ?? "")
                            .font(.subheadline.bold())
                        Text(item.modules?.moduleAuthor?.pubTimeText ?? "")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                if let desc = item.modules?.moduleDynamic?.desc?.text, !desc.isEmpty {
                    Text(desc)
                        .font(.body)
                        .lineLimit(6)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}
