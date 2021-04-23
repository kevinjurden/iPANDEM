//
//  ContentView.swift
//  Main view of the application also acts as the home/landing page
//
//  Created by Kevin Jurden on 3/12/21.
//

//Finish the home page, make it look better and be more informative

import SwiftUI
import UIKit

struct ContentView: View {
    @State var showMenu = false
    @State var showPreTest = false
    @State var showHelp = false
    @Binding var showResults: Bool
    @State var menuSelection = "Home"
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < 0 && $0.translation.height > -30 && $0.translation.height < 30 {
                    withAnimation {
                        self.showMenu = false
                    }
                } else if $0.translation.width > 0 && $0.translation.height > -30 && $0.translation.height < 30 {
                    withAnimation {
                        self.showMenu = true
                    }
                }
            }
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    MainView(showMenu: $showMenu, showResults: $showResults, showHelp: $showHelp, showPreTest: $showPreTest, menuSelection: $menuSelection)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                        .background(self.showMenu ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color(red: 255/255, green: 255/255, blue: 255/255))
                        .disabled(self.showMenu ? true : false)
                    if self.showMenu {
                        MenuView(showPreTest: $showPreTest, showHelp: $showHelp, showResults: $showResults, showMenu: $showMenu, menuSelection: $menuSelection)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .gesture(drag)
            }
            .navigationBarTitle("\(menuSelection)", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MainView: View {
    @Binding var showMenu: Bool
    @Binding var showResults: Bool
    @Binding var showHelp: Bool
    @Binding var showPreTest: Bool
    @Binding var menuSelection: String
    
    var body: some View {
        if self.showPreTest {
            PreTestInformationView(showPreTest: $showPreTest, showResults: $showResults)
        } else if self.showHelp {
            HelpView()
        } else {
            VStack {
                WelcomeText()
                UserImage()
                Text("Information about how to take test goes here")
                    .padding()
                Text("Video showing how to take the test goes here")
                    .padding()
                Text("Adverse effects sheet goes here")
                    .padding()
                Text("Other useful relevant information will go here")
                    .padding()
                Spacer()
                Button(action: {
                    self.showPreTest = true
                    self.menuSelection = "Pre-Test"
                }) {
                    Text("Go to the Pre-Test page")
                }.padding(.bottom, 10)
                Text("© Pandem Corp. All Rights Reserved")
                    .font(.system(size: 10))
                    
            }
        }
    }
}

struct WelcomeText: View {
    var body: some View {
        Text("Pandem Corp")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.top, 5)
        Text("Applied Technology Division")
            .padding(.bottom, 20)
            .font(.system(size: 13, weight: .semibold))
    }
}

struct UserImage: View {
    var body: some View {
        Image("Doctor")
            .resizable()
            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 50)
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var showResults = false
    
    static var previews: some View {
        ContentView(showResults: $showResults)
    }
}
