//
//  Constants.swift
//  Todoey
//
//  Created by Админ on 15.04.2023.
//

import Foundation
import CoreGraphics
import UIKit

struct Constants {
    
    struct Values {
        static let colors: [UIColor] = [.red, .yellow, .green]
    }
    
    struct Identifiers {
        static let itemTableViewCell = "ItemTableViewCell"
        
        static let cuSectionCollectionViewCell = "CUSectionCollectionViewCell"
        static let mainSectionCollectionViewCell = "MainSectionCollectionViewCell"
    }
    
    struct Colors {
        static let selectedMainCell = 0x96b9ff
        static let sections: [Int32] = [0xdf66e8, 0xdf66e8, 0x66e8e6, 0x66e87e, 0xd7e866, 0x86666]
    }
}
