
import SwiftUI

struct CardInfoView: View {
    @EnvironmentObject var userData: UserData
    let card: WalletCard
    var body: some View {
        VStack {
            CardInfoTop(c:card, color: colorsCard[card.id % 3])
                .frame(height:268)
                .transition(.move(edge: .bottom))
            
            ServicesScroll(needTitle: true, title: "Services", buttons: [
                buttonData(name:"Send",image: "sendButton"),
                buttonData(name:"Request",image: "requestButton"),
                buttonData(name:"Recharge",image: "rechargeButton"),
                buttonData(name:"Payment",image: "payButton")
            ])
            CardInfoSubsection(header: "Offers", images: ["saladOffer","summerOffer"])
            CardInfoSubsection(header: "Shopping", images: ["amazonOffer","walmartOffer"])
            Spacer()
                .navigationBarTitle("")
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarHidden(true)
        }.edgesIgnoringSafeArea(.all)
            .onAppear {
                self.userData.selectedCart = self.card
        }
        
    }
    init(_ card: WalletCard) {
        self.card = card
    }
}

struct CardInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CardInfoView(WalletCard(id: 5, cardHolder: "Rwan", balance: 30233, lastFourDigit: 3333, expireDate: "49/3", income: 33, expance: 33, currncy: "$"))
                
            }
            ContentView(homeViewModel: HomeViewModel(LocalRepository()))
            
        }
    }
}


struct CardInfoTop: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let c: WalletCard
    let color:[Color]
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: .init(colors:color), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing:20) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
                    Spacer()
                    PersonImage()
                }.padding([.trailing,.leading],20)
                    .padding(.top,70)
                VStack(alignment: .leading,spacing:30) {
                    CardInfoTopLeft(card:c)
                    cardPin(c.lastFourDigit)
                        
                        .padding([.leading,.trailing],20)
                        .padding(.top,10)
                    
                }
            }
        }.cornerRadius(10, corners: [.bottomLeft,.bottomRight])
            .shadow(radius: 10)
            
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 2, blendDuration: 1))
    }
}

struct CardInfoTopLeft: View {
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
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    //FIXME: SHOLD BE EDITED
                    Text("\(Int(card.balance))")
                        .font(.custom("Helvetica Neue", size: 35))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                Spacer()
                
                
                
            }
        }.padding([.leading,.trailing],30)
    }
}

struct ServiceButton: View {
    var name:String
    var image:String
    @State var isTouched = false
    var body: some View {
        VStack(spacing:25) {
            Image(image)
                .renderingMode(.original)

                .scaleEffect(isTouched ? 0.8: 1)
                
            Text(name)
                .font(.custom(Fonts.metropolis.rawValue, size: 15))
        }
//        .onTapGesture {
////            withAnimation {
////                self.isTouched.toggle()
////            }
//        }.animation(.interactiveSpring())
    }
}

struct ServicesScroll: View {
    var needTitle: Bool
    var title: String
    var buttons:[buttonData]
    var body: some View {
        VStack(spacing: 30) {
            
            HStack {
                if (self.needTitle) {
                Text(needTitle ? title: "")
                    .foregroundColor(Color("walletInfoColorSubHead"))
                    
                    .fontWeight(.light)
                Spacer()
                }
            }.padding([.trailing,.leading],20)
                .padding(.top,15)
            HStack(spacing:30) {
                
                ForEach(buttons) { data in
                    NavigationLink(
                        destination:Payment(paymentViewModel: PaymentViewModel(LocalRepository()))
                    ) {
                        
                    

                    ServiceButton(name: data.name, image: data.image)
                    }
                }
                
            }
        }
    }
}

struct OffersHeader: View {
    var name:String
    var body: some View {
        HStack {
            Text(name)
                .font(.custom(Fonts.metropolis.rawValue, size: 15))
                .fontWeight(.semibold)
                .foregroundColor(Color("walletInfoColorSubHead"))
            Spacer()
            Image(systemName: "arrow.right")
                .font(Font.system(.title).weight(.light))
                .foregroundColor(Color("arrowColor"))
            
        }.padding([.trailing,.leading],20)
    }
    init(_ name: String) {
        self.name = name
    }
}

struct OfferButton: View {
    let name:String
    var body: some View {
        Button(action: {
            
        }, label: {
            Image(name)
                .renderingMode(.original)
                .cornerRadius(7)
                
                .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 4)
                .padding(10)
            
        })
    }
    init(_ name: String) {
        self.name = name
    }
}

struct CardInfoSubsection: View {
    let header:String
    let images:[String]
    var body: some View {
        VStack {
            OffersHeader(header)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    
                    ForEach(images,id: \.self) { image in
                        OfferButton(image)
                        
                    }
                    
                    
                }
                
            }
        }
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct buttonData:Identifiable {
    let id = UUID()
    let name: String
    let image:String
    
}



extension UINavigationController: UIGestureRecognizerDelegate {
override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
}

public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
    }
    
}
