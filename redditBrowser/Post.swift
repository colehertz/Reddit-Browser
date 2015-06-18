//
//  Post.swift
//  redditBrowser
//
//  Created by Cole H on 6/17/15.
//  Copyright (c) 2015 Yep Technologies LLC. All rights reserved.
//

import Foundation

class Post: NSObject {

    var title:String!
    var author:String!
    var numberOfVotes:Int!
    var url:String!
    
    override init () {
    
    }
    
    init(t:String, a:String, number:Int, webURL:String) {
        title = t;
        author = a;
        numberOfVotes = number;
        url = webURL
        
        super.init()
    }
    
}