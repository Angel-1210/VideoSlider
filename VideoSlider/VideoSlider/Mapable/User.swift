//
//  User.swift
//  VideoSlider
//
//  Created by Dharmesh on 12/06/16.
//  Copyright © 2016 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import JSONModel

class User : JSONModel{
    
    var id : String!
    var name : String!
    var price : Float!
    
    init(fromDictionary dictionary: NSDictionary){
        super.init()
        
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        price = dictionary["price"] as? Float
    }
    
    required init(dictionary dict: [NSObject : AnyObject]!) throws {
        super.init()
        id = dict["id"] as? String
        name = dict["name"] as? String
        price = dict["price"] as? Float
    }
    
    required init(data: NSData!) throws {
        fatalError("init(data:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
