import SwiftUI
struct ContentView: View {
    @State private var showAlert = false
     @State private var showRatingView = false
     @State private var showStatisticsView = false
     @State private var timer: Timer?
     @State private var secondsLeft = 1 * 60
     @State private var progress: CGFloat = 0.0
     @State private var timerRunning = false
     @State private var tomato: Tomato? = nil
     @State private var inRestMode = false

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 15)
                    .fill(Color.gray.opacity(0.1))

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .foregroundColor(.red)
                    .rotationEffect(Angle(degrees: -90))

                Text(timeString(time: secondsLeft))
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(width: 250, height: 250)

            Spacer().frame(height: 40)

            Button(action: {
                if !timerRunning && !inRestMode {
                    startTimer()
                }
            }) {
                Text(timerRunning || inRestMode ? "⏸" : "🍅")
                    .font(.system(size: 50))
                    .foregroundColor((timerRunning || inRestMode) ? .gray : .blue)
                    .opacity((timerRunning || inRestMode) ? 0.5 : 1)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(timerRunning || inRestMode)

            Spacer().frame(height: 40)

            Button("查看统计") {
                showStatisticsView.toggle()
            }
            .sheet(isPresented: $showStatisticsView) {
                StatisticsView()
                    .frame(width: 800, height: 600)
            }

        }
        .frame(width: 200)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("25分钟工作时间已到"),
                  message: Text("请休息五分钟"),
                  dismissButton: .default(Text("确定")) {
                      startRestTimer()
                  })
        }
        .sheet(item: $tomato) { tomato in
            RatingView(tomato: tomato)
            
        }
    }
    func startTimer() {
           timer?.invalidate()
           timerRunning = true
           inRestMode = false
           timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
               secondsLeft -= 1
               progress = 1 - CGFloat(secondsLeft) / (25 * 60)

               if secondsLeft <= 0 {
                   timer.invalidate()
                   showAlert = true
                   timerRunning = false
               }
           }
       }

    
    func startRestTimer() {
        secondsLeft = 5 * 60
        progress = 0
        inRestMode = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            secondsLeft -= 1
            progress = 1 - CGFloat(secondsLeft) / (5 * 60)

            if secondsLeft <= 0 {
                timer.invalidate()
                tomato = Tomato(id: UUID(), date: Date(), rating: 0)
                showRatingView = true
                timerRunning = false
                inRestMode = false
                secondsLeft = 25 * 60
                progress = 0
            }
        }
    }

    func timeString(time: Int) -> String {
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
