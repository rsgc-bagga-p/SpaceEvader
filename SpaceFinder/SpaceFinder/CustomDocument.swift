//
//  CustomDocument.swift
//  SpaceFinder
//
//  Created by Puneet Bagga on 2019-02-17.
//  Copyright © 2019 SpaceEvaders. All rights reserved.
//

import Foundation
import AzureData

class CustomDocument: Document {
    
    var analog = Double()
    
    public override init () { super.init() }
    public override init (_ id: String) { super.init(id) }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        analog  = try container.decode(Double.self, forKey: .analog)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(analog,    forKey: .analog)
    }
    
    private enum CodingKeys: String, CodingKey {
        case analog
    }
}
