

import SwiftUI

struct RatingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var rating: Int = 0
    var tomato: Tomato

    var body: some View {
        VStack(spacing: 20) {
            Text("评价本次番茄时间质量")
                .font(.title)

            HStack(spacing: 10) {
                ForEach(1..<6) { index in
                    Button(action: {
                        rating = index
                        saveRating()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(index <= rating ? .yellow : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        // 添加背景颜色
        .cornerRadius(20) // 添加圆角边框
        .shadow(radius: 10) // 添加阴影效果
    }
    
    
    func saveRating() {
        let updatedTomato = Tomato(id: tomato.id, date: tomato.date, rating: rating)
        if let encodedData = try? JSONEncoder().encode(updatedTomato) {
            let key = "timegpt_tomatoes"
            var tomatoesData = UserDefaults.standard.array(forKey: key) as? [Data] ?? []
            tomatoesData.append(encodedData)
            UserDefaults.standard.set(tomatoesData, forKey: key)
        }
        }
    }

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(tomato: Tomato(id: UUID(), date: Date(), rating: 0))
          
            .previewLayout(.sizeThatFits)
    }
}
