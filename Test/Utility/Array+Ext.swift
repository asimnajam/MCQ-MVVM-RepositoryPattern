//
//  Array+Ext.swift
//  Test
//
//  Created by Admin on 22/02/2022.
//

import Foundation

extension Array {
    func get(index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
