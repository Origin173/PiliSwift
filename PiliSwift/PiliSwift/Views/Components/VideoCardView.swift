import SwiftUI

/// 可复用视频卡片组件
/// 用于 HomeView、HotView、SearchResult 等各处
struct VideoCardView: View {
    let item: RecVideoItem
    @Environment(Router.self) private var router

    var body: some View {
        Button {
            router.push(.videoDetail(.fromRecVideo(item)))
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                // 封面
                AsyncImage(url: URL(string: item.pic ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(.fill.secondary)
                            .overlay(Image(systemName: "play.circle").font(.title))
                    default:
                        Rectangle().fill(.fill.secondary)
                    }
                }
                .aspectRatio(16/9, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .bottomTrailing) {
                    Text(item.duration.formattedDuration)
                        .font(.caption2.bold())
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.black.opacity(0.7))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(4)
                }

                // 标题
                Text(item.title)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                // UP 主 + 播放量
                HStack(spacing: 6) {
                    Text(item.owner.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Label(item.stat.view.shortFormatted, systemImage: "play.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Int 格式化扩展
extension Int {
    /// 短格式化：1.2万、3.4亿
    var shortFormatted: String {
        if self >= 100_000_000 {
            return String(format: "%.1f亿", Double(self) / 100_000_000)
        } else if self >= 10_000 {
            return String(format: "%.1f万", Double(self) / 10_000)
        } else {
            return "\(self)"
        }
    }
}

extension Int {
    /// 视频时长格式化：mm:ss 或 hh:mm:ss
    var formattedDuration: String {
        let h = self / 3600
        let m = (self % 3600) / 60
        let s = self % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%02d:%02d", m, s)
        }
    }
}
