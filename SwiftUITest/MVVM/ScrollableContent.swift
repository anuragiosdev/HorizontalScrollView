import Foundation

class ScrollableContent: ObservableObject, Identifiable {
    let id =  UUID()
    let apiName: String
    @Published var isFocused: Bool = false
    init(apiName: String) {
        self.apiName = apiName
    }
}
