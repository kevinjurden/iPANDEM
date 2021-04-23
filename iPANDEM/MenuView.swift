//
//  MenuView.swift
//  Side Menu for navigating the pages within the Application
//
//  Created by Kevin Jurden on 3/12/21.
//

import SwiftUI

struct MenuView: View {
    @Binding var showPreTest: Bool
    @Binding var showHelp: Bool
    @Binding var showResults: Bool
    @Binding var showMenu: Bool
    @Binding var menuSelection: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.menuSelection = "Home"
                self.showPreTest = false
                self.showResults = false
                self.showHelp = false
                withAnimation {
                    self.showMenu.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "house")
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("Home")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .padding(.top, 100)
            }
            Button(action: {
                self.menuSelection = "Help"
                self.showPreTest = false
                self.showResults = false
                self.showHelp = true
                withAnimation {
                    self.showMenu.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("Help")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .padding(.top, 30)
            }
            Button(action: {
                self.menuSelection = "Consent Form"
                self.showPreTest = true
                self.showResults = false
                self.showHelp = false
                withAnimation {
                    self.showMenu.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("Consent Form")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .padding(.top, 30)
            }
            Button(action: {
                self.menuSelection = "Results"
                self.showPreTest = false
                self.showResults = true
                self.showHelp = false
                withAnimation {
                    self.showMenu.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "doc.on.clipboard")
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("Results")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .padding(.top, 30)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 255/255, green: 255/255, blue: 255/255))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct MenuView_Previews: PreviewProvider {
    @State static var showPreTest = false
    @State static var showHelp = false
    @State static var showResults = false
    @State static var showMenu = true
    @State static var menuSelection = "Home"
    
    static var previews: some View {
        MenuView(showPreTest: $showPreTest, showHelp: $showHelp, showResults: $showResults, showMenu: $showMenu, menuSelection: $menuSelection)
    }
}
