import Foundation

// MARK: - VideoDetailParams 工厂方法

extension VideoDetailParams {
    /// 从推荐视频列表项构造导航参数
    static func fromRecVideo(_ item: RecVideoItem) -> VideoDetailParams {
        VideoDetailParams(bvid: item.bvid, aid: item.aid)
    }
}

// MARK: - DynamicAuthor 计算属性

extension DynamicAuthor {
    /// 发布时间的可读文本，优先使用 pubAction，否则格式化 pubTs
    var pubTimeText: String {
        if let action = pubAction, !action.isEmpty { return action }
        guard let ts = pubTs else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(ts))
        let interval = Date().timeIntervalSince(date)
        if interval < 60 { return "刚刚" }
        if interval < 3600 { return "\(Int(interval / 60))分钟前" }
        if interval < 86400 { return "\(Int(interval / 3600))小时前" }
        if interval < 86400 * 30 { return "\(Int(interval / 86400))天前" }
        let fmt = DateFormatter()
        fmt.dateFormat = "MM-dd"
        return fmt.string(from: date)
    }
}

// MARK: - DynamicItem id 辅助

extension DynamicItem {
    /// 最终 idStr 不为空则安全使用
    var safeId: String { idStr.isEmpty ? "0" : idStr }
}

// MARK: - RecVideoItem 辅助

extension RecVideoItem {
    /// 便于调试或日志输出
    var shortDescription: String {
        "[\(bvid)] \(title)"
    }
}

// MARK: - MemberInfo mid 便捷

extension MemberInfo {
    // mid, name, face 均为非可选类型，直接使用即可
}

// MARK: - FollowItem 辅助

extension FollowItem {
    var isFollowing: Bool { attribute == 2 || attribute == 6 }
    var isMutual: Bool { attribute == 6 }
}
