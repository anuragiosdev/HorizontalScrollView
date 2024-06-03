//
//  ScrollContentViewModel.swift
//  SwiftUITest
//
//  Created by Anurag Sharma on 01/06/24.
//

import Foundation
import SwiftUI

class ScrollContentViewModel: ObservableObject {
    @Published var contents: [ScrollableContent] = []
    
    init() {
        setupContents()
    }
    
    func setupContents() {
        self.contents.append(ScrollableContent(apiName: "Parking"))
        self.contents.append(ScrollableContent(apiName: "Driver Seva"))
        self.contents.append(ScrollableContent(apiName: "Milk Delivery"))
        self.contents.append(ScrollableContent(apiName: "Tailor"))
        self.contents.append(ScrollableContent(apiName: "Car/Bike Wash"))
        self.contents.append(ScrollableContent(apiName: "Tiffin/Dabba"))
        self.contents.append(ScrollableContent(apiName: "Kitty Party"))
    }
}
