import SwiftUI

// MARK: - 搜索入口页
/// 对应 Flutter: lib/pages/search/view.dart
struct SearchView: View {
    @State private var query = ""
    @State private var viewModel = SearchViewModel()
    @Environment(Router.self) private var router

    var body: some View {
        VStack(spacing: 0) {
            // 搜索建议列表（输入中）
            if !query.isEmpty {
                SearchSuggestList(viewModel: viewModel, query: $query)
            } else {
                // 热搜列表
                SearchTrendingView()
            }
        }
        .searchable(text: $query, prompt: "搜索视频/UP主/番剧")
        .onSubmit(of: .search) {
            if !query.isEmpty {
                router.push(.searchResult(keyword: query))
            }
        }
        .onChange(of: query) { _, newValue in
            Task { await viewModel.fetchSuggestions(keyword: newValue) }
        }
        .navigationTitle("搜索")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 搜索建议列表
private struct SearchSuggestList: View {
    let viewModel: SearchViewModel
    @Binding var query: String
    @Environment(Router.self) private var router

    var body: some View {
        List(viewModel.suggestions, id: \.self) { suggestion in
            Button {
                query = suggestion
                router.push(.searchResult(keyword: suggestion))
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    Text(suggestion)
                }
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }
}

// MARK: - 搜索热门趋势
struct SearchTrendingView: View {
    @State private var viewModel = SearchTrendingViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                List(Array(items.enumerated()), id: \.offset) { index, item in
                    NavigationLink(value: Route.searchResult(keyword: item)) {
                        HStack {
                            Text("\(index + 1).")
                                .font(.subheadline.bold())
                                .foregroundStyle(index < 3 ? .orange : .secondary)
                                .frame(width: 28, alignment: .leading)
                            Text(item)
                        }
                    }
                }
                .listStyle(.plain)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "exclamationmark.triangle",
                                       description: Text(msg ?? ""))
            }
        }
        .task { await viewModel.load() }
    }
}

// MARK: - 搜索结果页
struct SearchResultView: View {
    let keyword: String
    @State private var viewModel: SearchResultViewModel

    init(keyword: String) {
        self.keyword = keyword
        _viewModel = State(initialValue: SearchResultViewModel(keyword: keyword))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let results):
                SearchResultList(results: results, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("搜索失败", systemImage: "magnifyingglass",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle(keyword)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.search() }
    }
}

// MARK: - 搜索结果列表
private struct SearchResultList: View {
    let results: [SearchResultItem]
    let viewModel: SearchResultViewModel

    var body: some View {
        List {
            ForEach(results) { item in
                SearchResultRow(item: item)
                    .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .listRowSeparator(.hidden)
            }

            Color.clear.frame(height: 1).onAppear {
                Task { await viewModel.loadMore() }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - 搜索结果行
private struct SearchResultRow: View {
    let item: SearchResultItem
    @Environment(Router.self) private var router

    var body: some View {
        Button {
            if item.type == "video", let bvid = item.bvid {
                router.push(.videoDetail(VideoDetailParams(bvid: bvid)))
            } else if item.type == "bili_user", let mid = item.mid {
                router.push(.member(mid: mid))
            }
        } label: {
            HStack(spacing: 10) {
                AsyncImage(url: URL(string: item.pic ?? "")) { img in
                    img.resizable().aspectRatio(16/9, contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(.fill.secondary)
                }
                .frame(width: 120, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title ?? "")
                        .font(.subheadline)
                        .lineLimit(2)
                    Text(item.author ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
