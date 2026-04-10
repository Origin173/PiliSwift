import SwiftUI

// MARK: - 私信列表
/// 对应 Flutter: lib/pages/whisper/view.dart
struct WhisperView: View {
    @State private var viewModel = WhisperViewModel()

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let sessions):
                List(sessions) { session in
                    NavigationLink(value: Route.whisperDetail(talkerId: session.talkerId)) {
                        WhisperSessionRow(session: session)
                    }
                }
                .listStyle(.plain)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "message.badge.rtl",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle("私信")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
    }
}

private struct WhisperSessionRow: View {
    let session: WhisperSession

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: session.talkerFace ?? "")) { img in
                img.resizable()
            } placeholder: {
                Circle().fill(.fill.secondary)
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(session.talkerName ?? "")
                    .font(.subheadline.bold())
                Text(session.lastContent ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - 私信对话页
struct WhisperDetailView: View {
    let talkerId: Int64
    @State private var viewModel: WhisperDetailViewModel

    init(talkerId: Int64) {
        self.talkerId = talkerId
        _viewModel = State(initialValue: WhisperDetailViewModel(talkerId: talkerId))
    }

    var body: some View {
        VStack(spacing: 0) {
            // 消息列表
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages) { msg in
                            MessageBubble(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _, _ in
                    if let last = viewModel.messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            Divider()

            // 输入框
            HStack(spacing: 10) {
                TextField("发送私信…", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)

                Button {
                    Task { await viewModel.sendMessage() }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .navigationTitle("私信")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
}

private struct MessageBubble: View {
    let message: WhisperMessage

    var body: some View {
        HStack {
            if message.isMine { Spacer() }
            Text(message.content)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(message.isMine ? Color.accentColor : Color(.systemGray5))
                .foregroundStyle(message.isMine ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            if !message.isMine { Spacer() }
        }
    }
}

// MARK: - 回复我
struct ReplyMeView: View {
    @State private var viewModel = ReplyMeViewModel()

    var body: some View {
        ReplyMessageList(viewModel: viewModel, title: "回复我的")
    }
}

// MARK: - @我
struct AtMeView: View {
    @State private var viewModel = AtMeViewModel()

    var body: some View {
        ReplyMessageList(viewModel: viewModel, title: "@我的")
    }
}

// MARK: - 赞我
struct LikeMeView: View {
    @State private var viewModel = LikeMeViewModel()

    var body: some View {
        ReplyMessageList(viewModel: viewModel, title: "收到的赞")
    }
}

// MARK: - 系统通知
struct SysMsgView: View {
    @State private var viewModel = SysMsgViewModel()

    var body: some View {
        ReplyMessageList(viewModel: viewModel, title: "系统通知")
    }
}

// MARK: - 通用消息列表视图（回复/at/赞/系统）
private struct ReplyMessageList<VM: MessageListViewModel>: View {
    let viewModel: VM
    let title: String

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let items):
                List(items, id: \.id) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.senderName)
                            .font(.subheadline.bold())
                        Text(item.content)
                            .font(.body)
                            .lineLimit(3)
                        Text(item.timeText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .listStyle(.plain)
            case .error(let msg, _):
                ContentUnavailableView("加载失败", systemImage: "bell.slash",
                                       description: Text(msg ?? ""))
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
}

// MARK: - 协议
protocol MessageListViewModel: AnyObject, Observable {
    var loadingState: LoadingState<[MessageItem]> { get }
    func load() async
}

struct MessageItem: Identifiable {
    let id: Int64
    let senderName: String
    let content: String
    let timeText: String
}

// MARK: - 主评论列表
/// 对应 Flutter: lib/pages/main_reply/view.dart
struct MainReplyView: View {
    let params: MainReplyParams
    @State private var viewModel: MainReplyViewModel

    init(params: MainReplyParams) {
        self.params = params
        _viewModel = State(initialValue: MainReplyViewModel(params: params))
    }

    var body: some View {
        Text("评论列表 (\(params.oid))")
            .navigationTitle("评论")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 我的回复
struct MyReplyView: View {
    var body: some View {
        Text("我的评论")
            .navigationTitle("我的评论")
            .navigationBarTitleDisplayMode(.inline)
    }
}
