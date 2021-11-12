//
//  Bindable.swift
//  Cartwheel
//
//  Created by Richmond Aisabor on 7/8/21.
//

import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet {
            
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        
        self.observer = observer
    }
}
