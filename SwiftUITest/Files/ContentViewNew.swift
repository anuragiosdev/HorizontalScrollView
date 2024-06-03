//
//  ContentViewNew.swift
//  SwiftUITest
//
//  Created by Anurag Sharma on 31/05/24.
//

import SwiftUI


struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.custom("HelveticaNeue-Bold", size: 18)) // Custom business-like font
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.9))
                        .shadow(radius: 5)
                )
        }
        .padding()
    }
}

struct ContentViewNew: View {
    @StateObject var viewModel = ScrollContentViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background") // Replace with your background image name
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all, edges: .all) // Ensures the image covers the entire screen
                
                VStack {
                    
                    Spacer()
                    HStack {
                        Text("Offered Services")
                            .font(.custom("HelveticaNeue-Bold", size: 22)) // Custom business-like font
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                            .padding(.bottom)
                        Spacer()
                    }.padding()
                    AnimatedScrollView(viewModel: viewModel) { item in
                        print("Clicked = \(item.apiName)")
                    }
                    .frame(height: 130)
                    .padding(.bottom, 12.0)
                    
                    CustomButton(title: "Continue") {}
                        .padding(.bottom, 50) // Padding to ensure the button is not at the very bottom edge
                }
                .padding()
            }
            
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("Onvira")
                        .font(.custom("HelveticaNeue-Bold", size: 40))
                        .foregroundColor(.white)
                        .padding([.top,.leading],16)
                    // Change the color of the title
                }
            }
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewNew()
    }
}
