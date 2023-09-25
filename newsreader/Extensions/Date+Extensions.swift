//
//  Date+Extensions.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/14.
//

import Foundation

// dateText() 関数: 日付を指定されたフォーマットで文字列に変換します。
// agoText() 関数: 指定された日時から現在までの経過時間を表示します。経過時間に合わせて適切な表現を提供します。

extension Date {
    static let dateFormatter: DateFormatter = {
        return DateFormatter()
    }()
    
    func dateText() -> String {
        Date.dateFormatter.dateFormat = "yyyy/MM/dd(E)"
        return Date.dateFormatter.string(from: self)
    }
    
    func agoText() -> String {
        let now = Date()
        let (earliest, latest) = self < now ? (self, now) : (now, self)
        let components = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second],
                                                         from: earliest, to: latest)
        if let year = components.year, year > 0 {
            return self.dateText()
        }
        if let month = components.month, month > 0 {
            return self.dateText()
        }
        if let weekOfYear = components.weekOfYear, weekOfYear > 0 {
            return self.dateText()
        }
        if let day = components.day, day > 0 {
            return "\(day)日前"
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour)時間前"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute)分前"
        }
        if let second = components.second, second > 0 {
            return "\(second)秒前"
        }
        return "たった今"
    }
}
