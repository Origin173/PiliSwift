import SwiftUI

// MARK: - UP 主主页
/// 对应 Flutter: lib/pages/member/view.dart
struct MemberView: View {
    let mid: Int64
    @State private var viewModel: MemberViewModel

    init(mid: Int64) {
        self.mid = mid
        _viewModel = State(initialValue: MemberViewModel(mid: mid))
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let info):
                MemberProfileContent(info: info, viewModel: viewModel)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "person.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("UP主")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
}

// MARK: - UP 主资料内容
private struct MemberProfileContent: View {
    let info: MemberInfo
    let viewModel: MemberViewModel

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    AsyncImage(url: URL(string: info.face)) { img in
                        img.resizable()
                    } placeholder: {
                        Circle().fill(.fill.secondary)
                    }
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(info.name)
                            .font(.title3.bold())
                        if let sign = info.sign, !sign.isEmpty {
                            Text(sign)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
                .padding(.vertical, 6)
            }

            Section {
                NavigationLink(value: Route.memberHome(mid: info.mid)) {
                    Label("TA 的主页", systemImage: "house")
                }
                NavigationLink(value: Route.memberVideo(mid: info.mid)) {
                    Label("TA 的投稿", systemImage: "video")
                }
                NavigationLink(value: Route.memberDynamics(mid: info.mid)) {
                    Label("TA 的动态", systemImage: "bell")
                }
                NavigationLink(value: Route.articleList(mid: info.mid)) {
                    Label("TA 的专栏", systemImage: "doc.text")
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - UP 主主页子页
struct MemberHomeView: View {
    let mid: Int64
    var body: some View {
        Text("UP主主页 (\(mid))")
            .navigationTitle("主页")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - UP 主动态
struct MemberDynamicsView: View {
    let mid: Int64
    @State private var viewModel = DynamicsViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                List(items) { item in
                    NavigationLink(value: Route.dynamicDetail(item.idStr)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.modules?.moduleDynamic?.desc?.text ?? "暂无内容")
                                .lineLimit(3)
                            Text(item.modules?.moduleAuthor?.pubTimeText ?? "")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "exclamationmark.triangle",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("动态")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadForMember(mid: mid) }
    }
}

// MARK: - UP 主投稿
struct MemberVideoView: View {
    let mid: Int64
    @State private var viewModel = MemberVideoViewModel(mid: 0)

    init(mid: Int64) {
        self.mid = mid
        _viewModel = State(initialValue: MemberVideoViewModel(mid: mid))
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
                }
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "exclamationmark.triangle",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("投稿")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
}

// MARK: - 个人资料编辑
struct MemberProfileView: View {
    var body: some View {
        Text("个人资料")
            .navigationTitle("个人资料")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - UP 主搜索
struct MemberSearchView: View {
    let mid: Int64
    @State private var query = ""
    var body: some View {
        VStack {
            TextField("搜索投稿", text: $query)
                .textFieldStyle(.roundedBorder)
                .padding()
            Text("搜索 UP 主投稿 (\(mid))")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .navigationTitle("投稿搜索")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 充电排行
struct UpowerRankView: View {
    let mid: Int64
    var body: some View {
        Text("充电排行榜 (\(mid))")
            .navigationTitle("充电排行")
            .navigationBarTitleDisplayMode(.inline)
    }
}
