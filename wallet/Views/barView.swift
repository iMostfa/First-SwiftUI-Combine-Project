//
//  barView.swift
//  wallet
//
//  Created by mostfa on 3/16/20.
//  Copyright © 2020 mostfa. All rights reserved.
//

import SwiftUI

struct barView: View {
    @State var picker = 1
    
    @Binding var numbers: [[Int]]
    
    var body: some View {
        
        VStack {
            GeometryReader { geometry in

            ScrollView(.horizontal, showsIndicators: true) {

                HStack(spacing:30)  {
                    
                    OnebarView(day: "S",value:self.numbers[self.picker][0],currentPicker: self.$picker)
                    OnebarView(day:"Sun",value:self.numbers[self.picker][1],currentPicker: self.$picker)
                    OnebarView(day: "M",value:self.numbers[self.picker][2],currentPicker: self.$picker)
                    OnebarView(day:"T",value:self.numbers[self.picker][3],currentPicker: self.$picker)
                    OnebarView(day: "W",value:self.numbers[self.picker][4],currentPicker: self.$picker)
                    OnebarView(day:"T",value:self.numbers[self.picker][5],currentPicker: self.$picker)
                    OnebarView(day:"F",value:self.numbers[self.picker][6],currentPicker: self.$picker)
                } .frame(width: geometry.size.width)
                    .frame(height:geometry.size.height - 90)
                   
                    .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
               
                }.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                 self.numbers[0] =         [210,80,140,150,80,50,100]
                             }
                             
                         }
            
            }.frame(height:340)
            
                
                Picker(selection: $picker, label: Text("")) {
                     Text("Visa").tag(1)
                    Text("Master").tag(0)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal,50)
                    .offset(y:-40)
         Spacer()
        }
    }
    
}

struct barView_Previews: PreviewProvider {
    static var previews: some View {
        // barView()
        
        Group {
            barView(numbers: .constant( [[20,10,200,90,100,50,30],[80,210,150,180,180,210,0],]))
        }
    }
}

struct OnebarView: View {
    var day = "M"
    var value = 200
     var colors = [Color(#colorLiteral(red: 0.445761621, green: 0.3171349764, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]
    @State var showDetails = false
    @Binding var currentPicker:Int

    var body: some View {
        VStack {
            
            ZStack {
                ZStack(alignment:.bottom) {
                    ZStack {
                    if showDetails {
                        ZStack {
                            Color.white
                                .frame(width:68)
                                .frame(height:30)
                                .cornerRadius(6)
                                .shadow(radius: 5)
                            Text("$\(value)")
                                .fontWeight(.semibold) .foregroundColor(Color.green)
                        }
                       
                        .opacity(showDetails ? 1 : 0)
                        .offset(y:CGFloat(-value + 55 ))
                        // .padding(-30)
                        
                        
                    }
                } .zIndex(1)
                    ZStack(alignment:.bottom) {
                        Capsule()
                            .frame(width:10)
                            .frame(height:210)
                            .shadow(color: colors[currentPicker].opacity(showDetails ? 1 : 0), radius: showDetails ? 5: 0, x: 0, y: 4)
                            .foregroundColor(showDetails ? Color(#colorLiteral(red: 0.6025797129, green: 0.6511667371, blue: 0.7168926001, alpha: 1)): Color(#colorLiteral(red: 0.6025797129, green: 0.6511667371, blue: 0.7168926001, alpha: 1)))
                        Capsule()
                            .frame(width:10)
                            .frame(height: CGFloat(value))
                            
                            
                            .foregroundColor(colors[currentPicker])
                        Color(#colorLiteral(red: 0.445761621, green: 0.3171349764, blue: 1, alpha: 1))
                            
                            .opacity(showDetails ? 1 : 0)
                            
                            .frame(width:16)
                            .frame(height:16)
                            .cornerRadius(8)
                            .overlay(Circle()
                                .stroke(Color.white, lineWidth: showDetails ? 6:6))
                            .opacity(showDetails ? 1 : 0)
                            
                            .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 0)
                            
                            
                            .offset(y:CGFloat(-value + 16))
                        
                    }
                    .zIndex(0)
                    .onTapGesture {
                        withAnimation {
                            print("me")
                            self.showDetails.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.showDetails = false
                            }
                        }
                    }
                }
            }.zIndex(1)
            Text(day)
                .fontWeight(.light)
                .font(.custom(Fonts.metropolis.rawValue, size: 12))
                .padding(.top,0)
                .padding(.bottom,13)
            .zIndex(0)
         
            
        }
    }
}


