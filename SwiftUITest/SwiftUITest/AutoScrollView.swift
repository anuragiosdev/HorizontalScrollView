import SwiftUI

struct ContentView: View {
    @State private var focusedIndex: Int? = nil
    @State private var scrollToIndex: Int = 0
    @State private var timer: Timer? = nil
    @State private var autoScrollComplete: Bool = false
    @State private var selectedItem: Int? = nil
    let items = Array(1...10)
    @State private var isAutoScrollCompleted = false
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(items, id: \.self) { item in
                            ItemView(item: item, isFocused: self.focusedIndex == item)
                                .id(item)
                                .onTapGesture {
                                    if autoScrollComplete {
                                        self.focusedIndex = item
                                        self.scrollToIndex = item
                                        self.selectedItem = item
                                    }
                                }
                                .background(
                                    NavigationLink(destination: DetailView(item: item), isActive: Binding(
                                        get: { self.selectedItem == item && self.autoScrollComplete },
                                        set: { isActive in
                                            if !isActive {
                                                self.selectedItem = nil
                                            }
                                        }
                                    )) {
                                        EmptyView()
                                    }
                                )
                        }
                    }
                    .padding()
                    .onChange(of: scrollToIndex) { target in
                        withAnimation {
                            proxy.scrollTo(target, anchor: .center)
                        }
                    }
                }
                .onAppear {
                    guard !isAutoScrollCompleted else {
                        return
                    }
                    startAutoScrolling()
                }
                .onDisappear {
                    stopAutoScrolling()
                }
            }
        }
    }
    
    func startAutoScrolling() {
        stopAutoScrolling() // Ensure no previous timer is running
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            if scrollToIndex < items.count {
                focusedIndex = items[scrollToIndex]
                scrollToIndex += 1
            } else {
                stopAutoScrolling()
                autoScrollComplete = true
            }
        }
    }
    
    func stopAutoScrolling() {
        timer?.invalidate()
        timer = nil
        isAutoScrollCompleted = true
    }
}

struct ItemView: View {
    let item: Int
    var isFocused: Bool
    
    var body: some View {
        Text("\(item)")
            .font(.system(size: isFocused ? 32 : 24))
            .foregroundColor(.white)
            .frame(width: isFocused ? 100 : 80, height: isFocused ? 100 : 80)
            .background(isFocused ? Color.blue : Color.gray)
            .cornerRadius(10)
            .animation(.easeInOut(duration: 0.3), value: isFocused)
    }
}

struct DetailView: View {
    let item: Int
    
    var body: some View {
        VStack {
            Text("Detail View for Item \(item)")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("Item \(item)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewNew()
    }
}
