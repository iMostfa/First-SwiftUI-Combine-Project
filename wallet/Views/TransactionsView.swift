//
//  Transactions.swift
//  wallet
//
//  Created by mostfa on 3/16/20.
//  Copyright © 2020 mostfa. All rights reserved.
//

import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var transactionsViewModel: TransactionsViewModel
    
    var body: some View {
        VStack {
        
                TransationsTop(c:self.userData.selectedCart!, color: self.userData.colorsCard[self.userData.selectedCart!.id % 3])
                    .edgesIgnoringSafeArea(.top)
               
              
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    barView(numbers: self.$transactionsViewModel.numbers)
                        
                    VStack {
                   List(transactionsViewModel.transactions) { transaction in
                                    
                                    transactionsList(hasNumbers:true,transaction: transaction)
                                    
                                    
                                    
                   }.frame(height:CGFloat(transactionsViewModel.transactions.count * 96))
                                    
                       
                            }
                    
                }
                
                
            }
            
          
            
        }
        .onAppear {
            UITableView.appearance().tableFooterView = UIView()
            UITableView.appearance().separatorStyle = .none
            self.transactionsViewModel.updateTransactions()
            self.updateAfterTime()
        }
        .navigationBarTitle("")
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        
    }
    //to mimic the update of data /* not supposed to be in the view, but in viewModel*/
    func updateAfterTime() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.transactionsViewModel.updateStatics()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.transactionsViewModel.numbers =    [
                [200,120,30,39,0,210,0],
                [80,210,150,180,180,210,0],
            ]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.transactionsViewModel.numbers =    [
                [80,210,150,180,180,210,0],
                [200,120,30,39,0,210,90],
                
            ]
        }
    }
}

struct Transactions_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(transactionsViewModel: TransactionsViewModel(LocalRepository()))
            .environmentObject(UserData(WalletCard(id: 1, cardHolder: "Rwan", balance: 30233, lastFourDigit: 3333, expireDate: "49/3", income: 3344, expance: 33, currncy: "$")))
    }
}


struct TransationsTop: View {
    @EnvironmentObject var userData: UserData
    
    let c: WalletCard
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
                    HStack(spacing:100) {
                        arrowView(image: "downGreen", value: self.userData.selectedCart!.income, text: "Income")
                        arrowView(image: "upRed", value: self.userData.selectedCart!.income, text: "Expance")
                    }
                    
                }
                
            }.cornerRadius(10, corners: [.bottomLeft,.bottomRight])
                .shadow(radius: 10)
                .animation(.interactiveSpring(response: 0.3, dampingFraction: 2, blendDuration: 1))
            
            
        }
    }
}

struct arrowView: View {
    var image:String
    var value:Double
    var text: String
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        HStack {
            
            Image(image)
            VStack(alignment:.leading) {
                Text(text)
                    .font(.custom(Fonts.metropolis.rawValue, size: 14))
                    .fontWeight(.regular)
                    .foregroundColor((Color("HolderColor")))
                HStack(spacing:1) {
                    Text(self.userData.selectedCart!.currncy)
                        .fontWeight(.medium)
                    Text("\(Int(value))")
                        .fontWeight(.medium)
                    
                }
                    
                .foregroundColor(Color.white) .font(.custom(Fonts.metropolis.rawValue, size: 24))
                
                
                
            }
        }
    }
}
