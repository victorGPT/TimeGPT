import SwiftUI

struct ContentView: View {
    @State private var showRatingView = false
    @State private var showStatisticsView = false
    @State private var showAlert = false
    @State private var timer: Timer?
    @State private var secondsLeft = 25 * 60
    @State private var progress: CGFloat = 0.0
    @State private var timerRunning = false
    
    var body: some View {
        ZStack {
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
                                if !timerRunning {
                                    startTimer()
                                }
                            }) {
                                Text(timerRunning ? "⏸" : "🍅")
                                    .font(.system(size: 50))
                                    .foregroundColor(timerRunning ? .gray : .blue)
                                    .opacity(timerRunning ? 0.5 : 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer().frame(height: 40)
                
                Button("查看统计") {
                    showStatisticsView.toggle()
                }
                .sheet(isPresented: $showStatisticsView) {
                    StatisticsView()
                        .frame(width: 500, height: 500)
                }

            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("25分钟工作时间已到"),
                      message: Text("请休息五分钟"),
                      dismissButton: .default(Text("确定")) {
                          startRestTimer()
                      })
            }
            .blur(radius: showAlert ? 5 : 0)

          
        }
        .frame(width: 200)
    }

    
    func startTimer() {
        timer?.invalidate()
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            secondsLeft -= 1
            progress = 1 - CGFloat(secondsLeft) / (25 * 60)
            
            if secondsLeft <= 0 {
                timer.invalidate()
                showAlert = true
            }
        }
    }
       
       func startRestTimer() {
           secondsLeft = 5   * 60
           progress = 0
           
           timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
               secondsLeft -= 1
               progress = 1 - CGFloat(secondsLeft) / (5 * 60)
               
               if secondsLeft <= 0 {
                   timer.invalidate()
                   showRatingView.toggle()
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
