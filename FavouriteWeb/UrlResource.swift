//
//  UrlResource.swift
//  FavouriteWeb
//
//  Created by Line Stettler & Marco Agovino on 10.06.17.
//  Copyright © 2017 Stettler & Agovino. All rights reserved.
//

import Foundation

// Protocol -> Schnittstelle
protocol UrlResource {
    // hole die Array-Liste aus FavouriteWeb
    func getList() -> [FavouriteWeb]
}
