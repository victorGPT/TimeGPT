import SwiftUI

struct Tomato: Codable, Identifiable {
    let id: UUID
    let date: Date
    let rating: Int
}

struct StatisticsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var tomatoes: [Tomato] = []
    @State private var groupedTomatoes: [Date: [Tomato]] = [:]
    
    var body: some View {
        VStack {
            HStack {
                Text("日期&星期")
                    .fontWeight(.bold)
                Spacer()
                Text("每日番茄个数")
                    .fontWeight(.bold)
                Spacer()
                Text("平均番茄质量")
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(groupedTomatoes.keys.sorted(by: >), id: \.self) { key in
                        HStack {
                            Text("\(getWeekdayString(from: key)), \(getDateFormattedString(from: key))")
                                .font(.headline)
                            Spacer()
                            let tomatoes = groupedTomatoes[key] ?? []
                            Text("数量：\(tomatoes.count)")
                            Spacer()
                            Text("平均质量：\(getAverageRating(for: key), specifier: "%.1f")")
                        }
                    }
                }
                .padding(.top)
            }
            
            Button("关闭") {
                dismiss()
            }
            .padding(.top)
        }
        .padding()
        .onAppear {
            groupTomatoes()
        }
    }
    
    func getDateFormattedString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func getWeekdayString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "zh_Hans")
        return dateFormatter.string(from: date)
    }
    
    func getAverageRating(for date: Date) -> Double {
        let tomatoesForDate = groupedTomatoes[date] ?? []
        let totalRating = tomatoesForDate.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(tomatoesForDate.count)
    }
    
    func groupTomatoes() {
        groupedTomatoes = Dictionary(grouping: tomatoes) { tomato in
            Calendar.current.startOfDay(for: tomato.date)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
