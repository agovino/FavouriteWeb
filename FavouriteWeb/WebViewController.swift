//
//  WebViewController.swift
//  FavouriteWeb
//
//  Created by Line Stettler & Marco Agovino on 10.06.17.
//  Copyright © 2017 Stettler & Agovino. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var superUrl: FavouriteWeb?
    
    override func loadView() {
        super.loadView()
        
        // URL holen
        guard  let superUrl = superUrl else {
            return
        }
        //siehe func in WebViewController
        if let url = URL(string: superUrl.getPrefixedUrl()) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
