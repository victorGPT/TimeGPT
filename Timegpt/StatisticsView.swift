import SwiftUI

struct StatisticsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tomatoes: [Tomato] = []

    var dailyTomatoCount: Int {
        tomatoes.count
    }
    
    var averageQuality: Double {
        guard !tomatoes.isEmpty else { return 0 }
        return Double(tomatoes.reduce(0) { $0 + $1.rating }) / Double(tomatoes.count)
    }

    var body: some View {
        VStack {
            Text("统计")
                .font(.title)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("今天完成的番茄时间数量：\(dailyTomatoCount)")
                Text("今天的平均番茄时间质量：\(averageQuality, specifier: "%.1f")")
            }
            .padding(.top)
            
            List {
                ForEach(tomatoes) { tomato in
                    HStack {
                        Text(tomato.startTime) // 显示番茄时间的起始时间
                        Spacer()
                        Text("\(tomato.rating) 星") // 显示番茄时间的评分情况
                    }
                }
            }
        }
        .padding()
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        let key = "timegpt_tomatoes"
        if let savedTomatoesData = UserDefaults.standard.array(forKey: key) as? [Data] {
            tomatoes = savedTomatoesData.compactMap { try? JSONDecoder().decode(Tomato.self, from: $0) }
        }
    }
}

struct Tomato: Identifiable, Codable {
    var id: UUID
    var startTime: String
    var rating: Int
}
