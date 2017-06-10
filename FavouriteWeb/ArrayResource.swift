//
//  ArrayResource.swift
//  FavouriteWeb
//
//  Created by Line Stettler & Marco Agovino on 10.06.17.
//  Copyright © 2017 Stettler & Agovino. All rights reserved.
//

import Foundation

// implementiert protocol UrlResource - holeListe
struct ArrayResource: UrlResource {

    func getList() -> [FavouriteWeb] {
        
        // leeres array erstellen -> superUrls
        var superUrls = [FavouriteWeb]()
        
        superUrls.append(FavouriteWeb(name: "FHNW", url: "http://www.fhnw.ch"))
        superUrls.append(FavouriteWeb(name: "Die Zeit", url: "http://www.zeit.de/news/index"))
        
        return superUrls
    }
}
