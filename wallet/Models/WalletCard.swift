//
//  WalletCard.swift
//  wallet
//
//  Created by mostfa on 3/13/20.
//  Copyright © 2020 mostfa. All rights reserved.
//

import Foundation
import Combine

struct  WalletCard:Identifiable{
    let id:Int
    let cardHolder: String
    let balance: Double
    let lastFourDigit: Int
    let expireDate: String
    let income: Double
    let expance: Double
    let currncy: String
    var isHeroEnabled: Bool = false

    
    
    
}
protocol ItemableData {
    var name:String {get set}
    var image: String {get set}
    var type:String {get set}
    
}
struct WalletTransaction:Identifiable,ItemableData {
    let id:Int
    var image:String
    var name:String
    var type:String
    let amount:String
    let sign:Signs
    var ShouldBeBig:Bool {
        get {
            if self.sign == .plus {
                return true
            }
            return false 
        }
    }
}
struct Company:ItemableData,Identifiable {
    var id:Int
    var name: String
    
    var image: String
    
    var type: String
    
    
    
}
class PaymentViewModel:ObservableObject {
  
    var cancallable:Set<AnyCancellable> = []
    var repo:WalletRespositry
    init(_ repo:WalletRespositry) {
        self.repo = repo
      
    }
    
    @Published var compaines:[Company] = [Company(id: 1, name: "Creative Electric Service", image: "creative", type: "14660 Beier Curve."),
    ]
    
    func updateCompanies() {
        guard compaines.count < 2 else {return}
        repo.fetchPaymentCompanies(for: nil)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (sup) in
                print(sup)
            }) { (company) in
                self.compaines.append(company)
        }.store(in: &cancallable)
    }
    
}
class TransactionsViewModel:ObservableObject {
  
    var cancallable:Set<AnyCancellable> = []
    @Published var transactions:[WalletTransaction] =    [
        WalletTransaction(id: 1, image: "dribble", name: "Dribble Inc.", type:"Payment", amount: "$45",sign:.minus),
        
    ]

    var repo:WalletRespositry
    init(_ repo:WalletRespositry) {
        self.repo = repo
      
    }
    
    @Published var compaines:[Company] = [Company(id: 1, name: "Creative Electric Service", image: "creative", type: "14660 Beier Curve."),
    ]
    @Published var numbers: [[Int]] =    [
        [200,120,30,39,0,210,0],
        [80,210,150,180,180,210,0],
    ]
    func updateTransactions() {
        repo.FetchTransactions().receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }) { (card) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4 ) {
                    self.transactions.append(card)
                    print("mee")
                }
        }.store(in: &cancallable)
        
    }
    func updateCompanies() {
        guard compaines.count < 2 else {return}
        repo.fetchPaymentCompanies(for: nil)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (sup) in
                print(sup)
            }) { (company) in
                self.compaines.append(company)
        }.store(in: &cancallable)
    }
    func updateStatics() {
        repo.fetchStatics()
        .receive(on: RunLoop.main)
        .collect(2)
        .sink(receiveCompletion: { (sup) in
                 print(sup)
             }) { (company) in
                self.numbers = company
         }.store(in: &cancallable)
        
        
    }
}
class HomeViewModel:ObservableObject {
    var cancallable:Set<AnyCancellable> = []
    @Published var cards  = [WalletCard(id: 50,cardHolder: "Rwan Adel", balance: 18240, lastFourDigit: 9089, expireDate: "20/4", income: 9999, expance: 29, currncy: "$")]
    @Published var transactions:[WalletTransaction] =    [
        WalletTransaction(id: 1, image: "dribble", name: "Dribble Inc.", type:"Payment", amount: "$45",sign:.minus),
        
    ]
    var repo:WalletRespositry
    init(_ repo:WalletRespositry) {
        self.repo = repo
    }
    
    func updateCards() {
        guard  cards.count < 0 else  {return}
        cards.removeFirst()
        repo.FetchCards().receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }) { (card) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 4 ) {
                    
                    self.cards.append(card)
                }
        }.store(in: &cancallable)
    }
    func moreCards() {
        self.cards.insert( .init(id: 1,cardHolder: "Mostfa Essam", balance: 10, lastFourDigit: 2020, expireDate: "20/22", income: 390, expance: 20221, currncy: "$"),
                           at: 0)
        
        //                    ,
        DispatchQueue.main.asyncAfter(deadline: .now() + 4 ) {
            self.cards.insert(         .init(id: 2,cardHolder: "Mostfffa Essam", balance: 10, lastFourDigit: 2020, expireDate: "20/22", income: 20221, expance: 390, currncy: "$"),
                                       at: 0)
        }
    }
    func updateTransactions() {
        repo.FetchTransactions().receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }) { (card) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4 ) {
                    self.transactions.append(card)
                    
                }
        }.store(in: &cancallable)
        
    }
    
    
}

class LocalRepository:WalletRespositry,ObservableObject {
    
    
    
    func FetchCards() -> AnyPublisher<WalletCard, RespositryError> {
        
        [
            .init(id: 0,cardHolder: "Rwan Adel", balance: 18240, lastFourDigit: 9089, expireDate: "20/4", income: 9999, expance: 29, currncy: "$"),
            
            
            ].publisher .mapError { error -> RespositryError in
                return RespositryError.Never(error: error)
        }.eraseToAnyPublisher()
    }
    
    func FetchTransactions() -> AnyPublisher<WalletTransaction, RespositryError> {
        [
            WalletTransaction(id: 2, image: "netflix", name: "Netflix", type:"payment", amount: "$15",sign:.minus),
            WalletTransaction(id: 3, image: "spotify", name: "Spotify", type: "payment", amount: "$163",sign:.plus),
            WalletTransaction(id: 4, image: "uber", name: "Uber", type: "payment", amount: "$35",sign:.minus),
            
            
            ].publisher .mapError { error -> RespositryError in
                return RespositryError.Never(error: error)
        }.eraseToAnyPublisher()
    }
    
    func FetchTransactions(for card: WalletCard) {
        
    }
    func fetchPaymentCompanies(for card: WalletCard? = nil ) -> AnyPublisher<Company, RespositryError> {
        
        [
            Company(id: 2, name: "Python Water Company", image: "python", type: "Burgerplatz 28, 15583 Eutin"),
            Company(id: 3, name: "Link3 Technologies Ltd.", image: "link", type: "6798 Dare Underpass"),
            Company(id: 4, name: "Sister", image: "sister", type: "Carmen Beltrán"),
            
            ].publisher .mapError { error -> RespositryError in
                return RespositryError.Never(error: error)
        }.eraseToAnyPublisher()
        
    }
    
    func fetchStatics() -> AnyPublisher<[Int], RespositryError>  {
        [
            [0,0,0,0,0,0,0],
            [80,210,150,180,180,210,0],
        ].publisher .mapError { error -> RespositryError in
                return RespositryError.Never(error: error)
        }.eraseToAnyPublisher()

    }
    
}

protocol WalletRespositry {
    
    func FetchCards() -> AnyPublisher<WalletCard,RespositryError>
    func FetchTransactions()  -> AnyPublisher <WalletTransaction, RespositryError>
    func FetchTransactions(for card:WalletCard)
    func fetchPaymentCompanies(for card: WalletCard?) -> AnyPublisher<Company, RespositryError>
    func fetchStatics() -> AnyPublisher<[Int], RespositryError>
    
}

enum RespositryError: Error{
    case Never(error: Error)
    
}

enum Signs:String,Equatable {
    case plus = "+"
    case minus = "-"
    
}


struct statics {
    var numbers:[[Int]]
}
