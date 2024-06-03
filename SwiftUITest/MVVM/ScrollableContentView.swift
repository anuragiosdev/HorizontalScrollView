import SwiftUI
struct ScrollableContentView: View {
    @ObservedObject var content: ScrollableContent
    var isFocused: Bool = false
    var hasPerformedAnimation: Bool = false
    @State private var progress: Double = 0.0
    
    init(content: ScrollableContent, isFocused: Bool, hasPerformedAnimation: Bool) {
        self.content = content
        self.isFocused = isFocused
        self.hasPerformedAnimation = hasPerformedAnimation
    }
    
    var shouldPerformAnimation: Bool {
        return !hasPerformedAnimation && isFocused
    }
    
    var changeByValue: CGFloat {
        return -10
    }
    
    var circleFrame: CGRect {
        CGRect(x: 0, y: 0, width: isFocused ? 120 + changeByValue: 90 + changeByValue, height: isFocused ? 120 + changeByValue: 90 + changeByValue)
    }
    
    var imageFrame: CGRect {
        CGRect(x: 0, y: 0, width: circleFrame.width - (circleFrame.width*60)/100, height: circleFrame.height - (circleFrame.width*60)/100)
    }
    
    var scrollContentFrame: CGRect {
        CGRect(x: 0, y: 0, width: isFocused ? 125 + changeByValue: 95 + changeByValue, height: isFocused ? 155 + changeByValue: 120 + changeByValue)
    }
    
    var circleOpacity: CGFloat{
        isFocused ? 1 : 0.6
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(isFocused ? Color.white : Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                    .opacity(circleOpacity)
                    .animation(.easeOut, value: isFocused ? 0.2 : 0)
                    .animation(.easeIn, value: !isFocused ? 0.2 : 0)
                
                if shouldPerformAnimation {
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .rotationEffect(Angle(degrees: -90))
                        .animation(Animation.linear(duration: 2.0), value: progress)
                        .onAppear {
                            self.progress = 1.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                self.progress = 0.0
                            }
                        }
                } // Slightly larger to align on border

                Image(systemName: "laptopcomputer.and.iphone")
                    .resizable()
                    .frame(width: imageFrame.width, height: imageFrame.height)
                    .foregroundColor(Color.red)
                    .opacity(circleOpacity)
                    .animation(.easeOut, value: isFocused ? 0.2 : 0)
                    .animation(.easeIn, value: !isFocused ? 0.2 : 0)

            }.frame(width: circleFrame.width, height: circleFrame.height)
            
            Text(content.apiName)
                .frame(width: circleFrame.width)
                .font(.custom("HelveticaNeue", size: content.isFocused ? 16 : 14))
                .foregroundColor(Color.white)
                .opacity(circleOpacity)
                .padding()
        }
        .frame(width: scrollContentFrame.width, height: scrollContentFrame.height)
            .padding()
        
    }
}
