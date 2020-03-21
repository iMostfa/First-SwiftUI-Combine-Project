/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores app data.
*/

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var selectedCart:WalletCard?
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
    init(_ card: WalletCard) {
        self.selectedCart = card
    }
    init() {
        
    }
 
}
