import SwiftUI

struct AnimatedScrollView: View {
    @StateObject private var timerManager = TimerManager(interval: 2, repeats: true)
    @State private var scrollViewCurrentIndex = 0
    @State private var isAutoScrollComplete = false
    @State private var currentSelectedView: ScrollableContent?
    @ObservedObject private var viewModel: ScrollContentViewModel
    @State var hasPerformedAnimation: Bool = false
    
    var onSelectAction: (ScrollableContent) -> Void
    
    init(viewModel: ScrollContentViewModel, onSelectAction: @escaping (ScrollableContent) -> Void) {
        self.viewModel = viewModel
        self.onSelectAction = onSelectAction
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -20) {
                    ForEach(viewModel.contents) { item in
                        ScrollableContentView(content: item, isFocused: item.id == currentSelectedView?.id, hasPerformedAnimation: hasPerformedAnimation)
                            .id(item.id)
                            .onTapGesture {
                                if isAutoScrollComplete {
                                    self.currentSelectedView =  item
                                    onSelectAction(item)
                                    //if want then
                                    proxy.scrollTo(item.id, anchor: .center)
                                }
                            }
                    }
                }
                .background(Color.clear)
                .fixedSize()
                .onChange(of: scrollViewCurrentIndex) { target in
                        withAnimation {
                            let scrollableContent = viewModel.contents[target-1]
                            let id = scrollableContent.id
                            proxy.scrollTo(id, anchor: .center)
                        }
                    }
            }
            .onAppear {
                setTimerForScrollView()
                startAutoScrolling()
            }
            .onDisappear {
                stopAutoScrolling()
            }
        }
    }
    
    private func setTimerForScrollView() {
        timerManager.setAction {
            ScrollToIndex()
        }
    }
}

protocol AutoScrollingProtocol {
    func startAutoScrolling()
    func stopAutoScrolling()
    func ScrollToIndex()
}

extension AnimatedScrollView: AutoScrollingProtocol {
    func startAutoScrolling() {
        stopAutoScrolling()
        // Ensure no previous timer is runnin
        timerManager.start()
    }
    
    func stopAutoScrolling() {
        timerManager.stop()
        isAutoScrollComplete = false
    }
    
    func ScrollToIndex() {
        if scrollViewCurrentIndex < viewModel.contents.count {
            currentSelectedView = viewModel.contents[scrollViewCurrentIndex]
            currentSelectedView?.isFocused = true
            scrollViewCurrentIndex += 1
        } else {
            scrollViewCurrentIndex = 1
            stopAutoScrolling()
            hasPerformedAnimation = true
            isAutoScrollComplete = true
        }
    }
}
