//
//  MonthView.swift of CalendarView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct MonthView: View {
    @Binding var selectedDate: Date?
    @Binding var selectedRange: MDateRange?
    let data: Data.MonthView
    let config: CalendarConfig


    var body: some View {
        LazyHStack(spacing: config.daysSpacing.vertical) {
            ForEach(data.items, id: \.last, content: createSingleRow)
        }
        .frame(maxHeight: .infinity)
        .animation(animation, value: selectedDate)
        .animation(animation, value: selectedRange?.getRange())
    }
}
private extension MonthView {
    func createSingleRow(_ dates: [Date]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
           let rows = generateRows(dates: dates)
           ForEach(rows, id: \.self) { row in
                  HStack(spacing: config.daysSpacing.horizontal) {
                       ForEach(dates, id: \.self, content: createDayView)
                   } 
           }
        }
    }

    // 手動計算行數，確保不超過螢幕寬度
    func generateRows(dates: [Date]) -> [[Date]] {
        var rows: [[Date]] = []
        var currentRow: [Date] = []
        var currentWidth: CGFloat = 0
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 40 // 預留 padding
        let itemWidth: CGFloat = 80 + 10 // 每個 item + spacing
        
        for date in dates {
            if currentWidth + itemWidth > maxWidth {
                rows.append(currentRow)
                currentRow = []
                currentWidth = 0
            }
            currentRow.append(date)
            currentWidth += itemWidth
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        return rows
    }
}
private extension MonthView {
    func createDayView(_ date: Date) -> some View {
        config.dayView(date, isCurrentMonth(date), $selectedDate, $selectedRange).erased()
    }
}
private extension MonthView {
    func isCurrentMonth(_ date: Date) -> Bool { data.month.isSame(.month, as: date) }
}

// MARK: - Others
private extension MonthView {
    var animation: Animation { .spring(response: 0.32, dampingFraction: 1, blendDuration: 0) }
}
