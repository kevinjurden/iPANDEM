//
//  HelpView.swift
//  Helpful area for users to find answer to questions or ask questions or get into contact with our team
//
//  Created by Kevin Jurden on 4/21/21.
//

import SwiftUI

struct HelpView: View {
    @State private var search = ""
    
    var body: some View {
        ZStack {
            VStack {
                Text("What can we help you with?")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24, weight: .medium, design: .serif))
                    TextField("Search", text: $search)
                        .font(.title)
                }
                .padding(.all, 5)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                )
                .padding(.bottom, 20)
                HStack(spacing: 30) {
                    Button(action: {
                        
                    }) {
                        VStack {
                            Image(systemName: "flame")
                                .font(.system(size: 30))
                                .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            Text("Testing")
                                .font(.system(size: 16, weight: .bold, design: .serif))
                                .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                .padding(.top, 10)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .background(Color(#colorLiteral(red: 0.8887129426, green: 0.6558366418, blue: 0.7138953805, alpha: 1)))
                    .cornerRadius(10)
                    
                    Button(action: {
                        
                    }) {
                        VStack {
                            Image(systemName: "flame")
                                .font(.system(size: 30))
                                .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            Text("Testing")
                                .font(.system(size: 16, weight: .bold, design: .serif))
                                .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                .padding(.top, 10)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .background(Color(#colorLiteral(red: 0.8887129426, green: 0.6558366418, blue: 0.7138953805, alpha: 1)))
                    .cornerRadius(10)
                    
                    Button(action: {
                        
                    }) {
                        VStack {
                            Image(systemName: "flame")
                                .font(.system(size: 30))
                                .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            Text("Testing")
                                .font(.system(size: 16, weight: .bold, design: .serif))
                                .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                .padding(.top, 10)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .background(Color(#colorLiteral(red: 0.8887129426, green: 0.6558366418, blue: 0.7138953805, alpha: 1)))
                    .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    
                }) {
                    Text("Next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 210, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color.blue)
                                .shadow(color: .gray, radius: 2, x: 0, y:2)
                        )
                        .padding(.bottom, 20)
                }
                Text("© Pandem Corp. All Rights Reserved")
                    .font(.system(size: 10))
            }
            .padding()
        }
        .background(Color.blue.opacity(0.075))
        .ignoresSafeArea(edges: .bottom)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HelpView()
        }
    }
}
