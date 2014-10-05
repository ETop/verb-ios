//
//  ActivityViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

//class CustomTableViewCell : UITableViewCell {
//
//  @IBOutlet var mylabel: UILabel!
//  @IBOutlet var button1: UIButton!
//  @IBOutlet var button2: UIButton!
//  @IBOutlet var myContentView: UIView!
//  var model: ActivityModel?
//
//  required init(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//
//  @IBAction func buttonClicked(sender: AnyObject) {
//    
//  }
//}

class ActivityViewController: UITableViewController {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  var verbAPI: VerbAPI
  var activityModelList: NSMutableArray = []
  
  required init(coder aDecoder: NSCoder) {
    self.verbAPI = appDelegate.getVerbAPI()
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    
    
//    var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
//    
//    tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
    
    super.viewDidLoad()
    // adds the pull to refresh interface
    var refresh = UIRefreshControl()
    refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refresh.addTarget(self, action:"loadData", forControlEvents:.ValueChanged)
    self.refreshControl = refresh
    
    // get the initial data
    loadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
     return self.activityModelList.count
    }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //let CellIdentifier: NSString = "ListPrototypeCell"
    //var cell : CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as CustomTableViewCell
    var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var activityModel: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    cell.textLabel!.text = activityModel.activityMessage
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var activity: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    verbAPI.acknowledgeMessage(activity.message, callback: { response in
      self.loadData()
    })
    println("You selected cell #\(indexPath.row): \(activity.activityMessage)!")
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      activityModelList.removeObjectAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
  
  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

    var activity: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel

    var reciprocate = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "\(activity.message.verb) back!", handler:{action, indexpath in
      println("RECIPROCATE•ACTION");
      self.tableView.setEditing(false, animated: true)
      self.verbAPI.reciprocateMessage(activity.message, callback: { response in
        self.loadData()
      })
    });
    reciprocate.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
    
    var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
      println("DELETE•ACTION");
    });

    if activity.type == "received" {
      return [reciprocate]
    }
    else {
      return []
    }
  }

  func loadData() {
    verbAPI.getActivities({ activities in
      self.activityModelList = []
      for (index: String, activity: JSON) in activities {
        // Wow, this sucks.
        var senderUserModel = UserModel(
          id: activity["message"]["sender"]["id"].integerValue,
          email: activity["message"]["sender"]["email"].stringValue,
          firstName: activity["message"]["sender"]["first_name"].stringValue,
          lastName: activity["message"]["sender"]["last_name"].stringValue
        )

        var recipientUserModel = UserModel(
          id: activity["message"]["recipient"]["id"].integerValue,
          email: activity["message"]["recipient"]["email"].stringValue,
          firstName: activity["message"]["recipient"]["first_name"].stringValue,
          lastName: activity["message"]["recipient"]["last_name"].stringValue
        )

        var messageModel = MessageModel(
          id: activity["message"]["id"].integerValue,
          verb: activity["message"]["verb"].stringValue,
          acknowledgedAt: activity["message"]["acknowledged_at"].integerValue,
          acknowlegedAtInWords: activity["message"]["acknowledged_at_in_words"].stringValue,
          createdAt: activity["message"]["created_at"].integerValue,
          createdAtInWords: activity["message"]["created_at_in_words"].stringValue,
          sender: senderUserModel,
          recipient: recipientUserModel
        )

        var activityModel = ActivityModel(activity: activity, message: messageModel)
        self.activityModelList.addObject(activityModel)
      }
      self.refreshControl!.endRefreshing()
      self.tableView.reloadData()
    })
  }
}