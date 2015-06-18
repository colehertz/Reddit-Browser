//
//  ViewController.swift
//  redditBrowser
//
//  Created by Cole H on 6/17/15.
//  Copyright (c) 2015 Yep Technologies LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var tableView: UITableView!
    var posts: [Post] = []
    var refreshControl: UIRefreshControl!
    var subreddit = ""
    var selectedPost:Post!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.setNeedsDisplay()
        
        nameField.delegate = self;
        
    
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    
        
    }
    
    override func viewWillAppear(animated: Bool) {
     
        tableView.reloadData()
    }
    
    @IBAction func findPressed(sender: AnyObject) {
        nameField.resignFirstResponder()
        
        subreddit = nameField.text;
        println("find pressed:" + subreddit)
        
        if (subreddit != "") {
            refresh();
            tableView.reloadData()
        } else {
            println("subreddit is nil")
        }
    
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("textfield should return");
        if (textField == nameField) {
           // subreddit = nameField.text
           // refresh()
        }
        
        textField.resignFirstResponder()
        
        
        return true;
    }
    
    func refresh () {
    
        println("tableview refreshed")
        println(subreddit)
        
        
        if (subreddit != "") {
            request(.GET, "http://www.reddit.com/r/"+subreddit+".json?limit=5")
                .responseJSON {(_, _, json, _) in
                
                    var result = JSON(json!);
                
                    self.posts.removeAll();
                
                    for (var i = 0; i < result["data"]["children"].count; i++) {
                        var title = result["data"]["children"][i]["data"]["title"].stringValue
                        var author = result["data"]["children"][i]["data"]["author"].stringValue
                        var number = result["data"]["children"][i]["data"]["ups"].intValue
                        var url = result["data"]["children"][i]["data"]["url"].stringValue
                        
                        var post: Post = Post(t: title, a: author, number: number, webURL:url);
                        self.posts.append(post);
                        
                        self.Dispatcher(self.tableView.reloadData)
                        
                    }
            
                    
                }
            }
        
      //  dispatch_async(dispatch_get_main_queue(), self.tableView.reloadData);
        refreshControl.endRefreshing()
    
    
    }
    

    func Dispatcher(functionToRunOnMainThread: () -> ())
    {
        dispatch_async(dispatch_get_main_queue(), functionToRunOnMainThread)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(tableview: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: CustomCell = self.tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! CustomCell
        
        cell.titleLabel.text = posts[indexPath.row].title
        cell.authorLabel.text = posts[indexPath.row].author
        cell.upvotesLabeL.text = "up votes:" + " " + String(posts[indexPath.row].numberOfVotes)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedPost = self.posts[indexPath.row]
        println("post:")
        println(selectedPost)
        self.performSegueWithIdentifier("infoSegue", sender: self);
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "infoSegue" {
            var destinationVC = segue.destinationViewController as! PostDetails
            destinationVC.selectedPost = selectedPost;
        }
    }
    


}

