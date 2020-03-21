//
//  ContentView.swift
//  wallet
//
//  Created by mostfa on 3/13/20.
//  Copyright © 2020 mostfa. All rights reserved.
//

import SwiftUI
struct ContentView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    @EnvironmentObject var userData: UserData

    @State var offsett = true
    var body: some View {
        NavigationView {
            VStack(spacing: 35) {
                VStack {
                    topView()
                        .onTapGesture {
                            withAnimation {
                            self.homeViewModel.moreCards()
                            }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollableCard(cards: homeViewModel.cards, colors: self.userData.colorsCard).onAppear {
                            withAnimation {

                            self.homeViewModel.updateCards()
                            }
                        }
                        .padding([.top,.bottom], 10)
                        
                        
                        
                    }
                    
                }

                VStack {
                    HStack {
                        Text("Transactions")
                            .font(.custom(Fonts.metropolis.rawValue, size: 15))
                            .fontWeight(.semibold)
                        Spacer()
                        NavigationLink(destination:            TransactionsView(transactionsViewModel: TransactionsViewModel(LocalRepository()))) {
                        Image(systemName: "arrow.right")
                            .renderingMode(.original)
                            .font(Font.system(.title).weight(.light))
                        }
                    }.padding([.trailing,.leading],25)
                    List(homeViewModel.transactions) { transaction in
                        
                        transactionsList(hasNumbers:true,transaction: transaction)
                        
                        
                        
                    }
                        
                    .onAppear {
                        UITableView.appearance().tableFooterView = UIView()
                        UITableView.appearance().separatorStyle = .none
                        self.homeViewModel.updateTransactions()
                    }
                }
                
                
                
                
            }
            .background(Color.init(red: 250.0/255.0, green: 252.0/255.0, blue: 255.0/255.0))
            //FAFCFF
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(homeViewModel: HomeViewModel(LocalRepository())).environmentObject(UserData())
    }
}



enum Fonts: String {
    case ocrText = "OCR A Extended"
    case metropolis = "Metropolis"
    
}



struct topView: View {
    var body: some View {
        HStack {
            Text("Your Wallet")
                .font(.custom(Fonts.metropolis.rawValue, size: 24))
                .fontWeight(.bold)
                .foregroundColor(.init("WalletColor"))
            Spacer()
            PersonImage()
        }.padding([.leading,.trailing], 20)
            .padding([.bottom,.top],30)
    }
}

struct CardTop: View {
    let card:WalletCard
    var body: some View {
        VStack(alignment: .leading,spacing:0) {
            Text("Balance")
                
                .font(.custom(Fonts.metropolis.rawValue, size:10))
                
                
                .fontWeight(.regular)
                .foregroundColor(Color("HolderColor"))
            HStack {
                HStack(spacing: 0){
                    Text(card.currncy)
                        .font(.custom("Helvetica Neue", size: 24))
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                    //FIXME: SHOLD BE EDITED
                    Text("\(Int(card.balance))")
                        .font(.custom("Helvetica Neue", size: 24))
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                }.padding(.leading, 3)
                Spacer()
                Image("visaLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
                    .frame(width:52.4,height:16.6)
                
                
                
                
            }
        }.padding([.leading,.trailing],30)
    }
}

struct cardPin: View {
    let lastFourDigits:Int
    private var numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .none
        return f
    }()
    //FIXME: SHOULD NOT USE NSSNUMBER FOR NO REASON?
    var body: some View {
        Text("**** **** ****  \(numberFormatter.string(from: NSNumber(value: lastFourDigits))!)")
            .font(.custom(Fonts.ocrText.rawValue, size: 23))
            .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0, y: 3)
            .padding(.top,0)
            .foregroundColor(Color.white)
            //  .padding([.leading,.trailing],10)
            .fixedSize(horizontal: false, vertical: true)
    }
    init(_ lastFourDigits:Int) {
        self.lastFourDigits = lastFourDigits
    }
}


struct leftBottomCard: View {
    let card:WalletCard
    var body: some View {
        VStack(alignment:.leading) {
            Text("CARD HOLDER")
                .font(.custom("Helvetica", size: 7))
                //D3DDE5
                .fontWeight(.regular)
                .foregroundColor(Color("HolderColor"))
            Text(card.cardHolder)
                .foregroundColor(Color.white)
                .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0, y: 3)
                .font(.custom(Fonts.ocrText.rawValue, size: 15))
            
            
            
            
        }
    }
    init(_ card:WalletCard){
        self.card = card
    }
}

struct rightBottomCard: View {
    let card:WalletCard
    var body: some View {
        VStack(alignment:.leading) {
            Text("EXPIRES")
                .font(.custom("Helvetica", size: 7))
                //D3DDE5
                .fontWeight(.regular)
                .foregroundColor(Color("HolderColor"))
            Text(card.expireDate)
                .foregroundColor(Color.white)
                .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0, y: 3)                .font(.custom(Fonts.ocrText.rawValue, size: 15))
            
            
            
            
        }
    }
    init(_ card:WalletCard){
        self.card = card
    }
}

struct transactionsList: View {
    //I'm exposing some of the data types to this view, but i want it to be reusable
    let hasNumbers:Bool
    let transaction:ItemableData
    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(8)
                .shadow(radius: 1).opacity(0.40)
            HStack {
                HStack {
                    Image(transaction.image)
                        .resizable()
                        .frame(width:56,height:56)
                        .padding([.top,.bottom],10)
                    VStack(alignment: .leading ,spacing:5) {
                        Text(transaction.name)
                            .font(.custom(Fonts.metropolis.rawValue, size: 16))
                            .fontWeight(.semibold)
                        Text(transaction.type)
                            .font(.footnote)
                    }
                    
                    
                }
                Spacer()
                HStack {
                HStack(spacing:0) {
                    if self.hasNumbers {
                    Text((transaction as? WalletTransaction)!.sign.rawValue)
                         .foregroundColor(Color.green)
                    Text((transaction as? WalletTransaction)!.amount).fontWeight((transaction as? WalletTransaction )!.ShouldBeBig ? .bold: .light)
                         .foregroundColor(Color.green)
                   
                      .font((transaction as? WalletTransaction )!.ShouldBeBig ? .custom(Fonts.metropolis.rawValue, size: 20): .custom(Fonts.metropolis.rawValue, size: 20 ))
                    }
                   
                }
                }

                
                
                
                
                
            }
            .padding([.leading,.trailing],10)
            
        }
        
    }
}

struct ScrollableCard: View {
    var cards: [WalletCard]
    var colors: [[Color]]
    @State var dragAmount = CGSize.zero
    
    
    var body: some View {
        HStack(spacing:0){
            ForEach(cards){c in
                NavigationLink (destination: CardInfoView(c)) {
                    
                GeometryReader { geometry in
                    CardView(c: c, color:  self.colors[c.id % 3])
                        .cornerRadius(10)
                        .rotation3DEffect(Angle(degrees:
                            Double(geometry.frame(in: .global).minX - 5) / -30), axis: (x: 0, y: 120.0, z: 0))
                    
                }   .frame(width:320,height:220)
                    .shadow(color: self.colors[c.id % 3][1], radius: 8, x: 0, y: 0)
                    .animation(.interpolatingSpring(stiffness: 2, damping: 2))
                
                
                }
            }
        }.padding(5)
    }
    func setId() {
        
    }
}

struct CardView: View {
    let c: WalletCard
    let color:[Color]
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: .init(colors:color), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing:30) {
                CardTop(card:c)
                cardPin(c.lastFourDigit)
                HStack {
                    leftBottomCard(c)
                    Spacer()
                    rightBottomCard(c)
                }
                .padding([.leading,.trailing],20)
                .padding(.top,10)
                
            }
        }
        .shadow(color: Color(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.41)), radius: 4, x: 0, y: 3)
            
        .animation(.interactiveSpring(response: 0.3, dampingFraction: 2, blendDuration: 1))
    }
}


let colorsCard:[[Color]] = [
    [
        Color.init(red: 255.0/255.0, green: 103.0/255.0, blue: 103.0/255.0),
        Color.init(red: 255.0/255.0, green: 133.0/255.0, blue: 133.0/255.0),
    ]
    ,
    [
        
        Color.init  (red: 74.0/255.0, green: 39.0/255.0, blue: 243.0/255.0),
        Color.init (red: 68.0/255.0, green: 75.0/255.0, blue: 177.0/255.0),
    ]
    ,
    [
        //UIColor(red: 44.0/255.0, green: 180.0/255.0, blue: 136.0/255.0)
        Color.init(red: 44.0/255.0, green: 180.0/255.0, blue: 136.0/255.0),
        
        Color.init(red: 32.0/255.0, green: 157.0/255.0, blue: 146.0/255.0),
    ]
]

struct PersonImage: View {
    var body: some View {
        Image("person")
            .resizable()
            .frame(width:28,height:28)
            .cornerRadius(8)
    }
}
