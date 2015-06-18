//
//  PostDetails.swift
//  redditBrowser
//
//  Created by Cole H on 6/17/15.
//  Copyright (c) 2015 Yep Technologies LLC. All rights reserved.
//

import Foundation
import UIKit

class PostDetails: UIViewController {
    @IBOutlet var webView: UIWebView!
    var selectedPost = Post();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        var url = NSURL(string: selectedPost.url)
        var request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBackPressed(sender:AnyObject!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}