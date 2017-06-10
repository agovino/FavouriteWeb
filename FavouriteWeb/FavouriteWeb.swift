//
//  FavouriteWeb.swift
//  FavouriteWeb
//
//  Created by Line Stettler & Marco Agovino on 10.06.17.
//  Copyright © 2017 Stettler & Agovino. All rights reserved.
//

//  Data-Model -> um Datensätze zu repräsentieren

import Foundation

// struct - da datensatz als value-type
struct FavouriteWeb {
    var name:String
    var url: String
    
    func getPrefixedUrl() -> String {
        if url.range(of: "^(http|https)", options: .regularExpression, range: nil, locale: nil) != nil {
            
            return url
        }
        
        return "http://\(url)"
    }
}



