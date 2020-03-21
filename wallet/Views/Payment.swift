//
//  Payment.swift
//  wallet
//
//  Created by mostfa on 3/15/20.
//  Copyright © 2020 mostfa. All rights reserved.
//

import SwiftUI

struct Payment: View {
    @ObservedObject var paymentViewModel: PaymentViewModel
    @EnvironmentObject var userData: UserData

    @State var number: String = ""
    @State var shown: Bool = true
    var body: some View {
        ZStack(alignment:.bottom) {
            
            VStack(spacing:-40) {
                
                paymentTop(c:userData.selectedCart!, tetxt: $number, color: self.userData.colorsCard[userData.selectedCart!.id % 3])
                    .frame(height:220)
                    .edgesIgnoringSafeArea(.all)
                    .simultaneousGesture(DragGesture()
                        
                        .onEnded{_ in
                            withAnimation(Animation.easeInOut) {
                                self.shown.toggle()
                            }
                        }
                )
                
                
                VStack {
                    ServicesScroll(needTitle: false, title: "", buttons: [
                        buttonData(name:"Electric",image: "electric"),
                        buttonData(name:"Water",image: "water"),
                        buttonData(name:"Internet",image: "internet"),
                        buttonData(name:"Payment",image: "payment")
                    ])
                    
                    
                    List(paymentViewModel.compaines) { company in
                        transactionsList(hasNumbers: false, transaction: company) }
                        .onAppear {
                            UITableView.appearance().tableFooterView = UIView()
                            UITableView.appearance().separatorStyle = .none
                            self.paymentViewModel.updateCompanies()
                            
                    }.edgesIgnoringSafeArea(.bottom)
                        .zIndex(0)
                        .onLongPressGesture {
                            withAnimation(Animation.easeInOut) {
                                self.shown.toggle()
                                
                                
                            }
                    }
                    
                    
                    Spacer()
                }
            }
            if shown {
                ZStack {
                    Color("purbleQr").opacity(shown ? 1 : 0.3)
                    HStack {
                        Image("qr")
                            .resizable()
                            .frame(width:19, height:19)
                        Text("Scan QR Code")
                            .font(.custom(Fonts.metropolis.rawValue, size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                        
                    }
                    
                }.frame(width:182,height:47)
                    .transition(.asymmetric(insertion: .moveAndScale, removal: .moveAndScale))
                    .opacity(shown ? 1 : 0.3)
                    .animation(nil)
                    .zIndex(1)
                    .cornerRadius(shown ? 24: 0)
                    .shadow(color:shown ?   Color.black.opacity(0.3): Color("purbleQr"), radius: shown ? 10: 15, x: 0, y: 3)
                
            }
        }           .navigationBarTitle("")
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
    }
    
}
struct Payment_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Payment(paymentViewModel: PaymentViewModel(LocalRepository()))
        }
    }
}

struct paymentTop: View {
    
    let c: WalletCard
    @Binding var tetxt:String
    let color:[Color]
    var body: some View {
        ZStack{
            
            
            ZStack{
                
                LinearGradient(gradient: .init(colors:color), startPoint: .top, endPoint: .bottom)
                    .frame(height:223)
                
                VStack(spacing:20) {
                    HStack {
                        HStack(spacing:20) {
                            backButton()
                            Text("Transactions")
                                .font(.custom(Fonts.metropolis.rawValue, size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                        Spacer()
                        PersonImage()
                    }.padding([.trailing,.leading],20)
                        .padding(.top,70)
                    VStack(alignment: .leading,spacing:30) {
                        
                        ZStack {
                            Color.white
                                .cornerRadius(5)
                            
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color("walletInfoColorSubHead"))
                                    
                                    .padding(.leading,5)
                                TextField("Search payment options", text: self.$tetxt)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                        }.frame(height:30)
                            .frame(idealWidth:332,maxWidth:490)
                            .padding([.trailing,.leading],20)
                            .padding(.bottom,15)
                    }
                    
                }
                
            }.cornerRadius(10, corners: [.bottomLeft,.bottomRight])
                .shadow(radius: 10)
                .animation(.interactiveSpring(response: 0.3, dampingFraction: 2, blendDuration: 1))
            
            
        }
    }
}

struct backButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .font(.title)
                .foregroundColor(Color.white)
        }
    }
}

extension AnyTransition {
    static var moveAndScale: AnyTransition {
        AnyTransition.move(edge: .bottom).combined(with: .scale)
    }
}
