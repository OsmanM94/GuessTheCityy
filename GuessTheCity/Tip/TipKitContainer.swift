//
//  TipKitContainer.swift
//  GuessTheCity
//
//  Created by asia on 07.10.2024.
//

import Foundation
import TipKit

struct LocationNameTip: Tip {
    var title: Text {
        Text("Location Hint")
    }
    
    var message: Text? {
        Text("This hint describes the first letter and the last letter of the location name.")
    }
    
    var image: Image? {
        Image(systemName: "info.circle")
    }
}
