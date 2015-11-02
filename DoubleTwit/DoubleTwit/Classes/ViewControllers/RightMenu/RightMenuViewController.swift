//
//  RightMenuViewController.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 22/09/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit

 /// Part of the application's navigation - right menu view controller. Presenting today games list (pulled from the Backendless)

class RightMenuViewController: UIViewController {

    @IBOutlet weak var gamesTableView: UITableView!
    
    // Array for keeping a list of today games
    var gamesList = NSMutableArray()
    // Instance of the Backendless for sending API requests
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pull Data from Backendless - requesting only games for current day
        let cal: NSCalendar = NSCalendar.currentCalendar()
        cal.timeZone = NSTimeZone.systemTimeZone()
        let date: NSDate = NSDate()
        let comps: NSDateComponents = cal.components([.Year, .Month, .Day], fromDate: date)
        let today: NSDate = cal.dateFromComponents(comps)!
        let tomorrow = today + 1.days
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        
        // Setting sort by date of game
        let queryOptions: QueryOptions = QueryOptions()
        queryOptions.sortBy(["dateOfGame"])
        
        let query: BackendlessDataQuery = BackendlessDataQuery()
        query.queryOptions = queryOptions
        query.whereClause = "dateOfGame after '" + dateFormatter.stringFromDate(today) + "' AND dateOfGame before '" + dateFormatter.stringFromDate(tomorrow) + "'"
        
        backendless.persistenceService.of(GamesCalendar.ofClass()).find(
            
            query, response: { (results: BackendlessCollection!) -> () in
                
                let currentPage = results.getCurrentPage()
                
//                print("Total results in the Backendless storage - \(results.totalObjects)")
                
                // Saving all data into the mutable array and forcing table view reload
                for result in currentPage as! [GamesCalendar] {
                    self.gamesList.addObject(result)
                }
                
                self.gamesTableView.reloadData()
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            
            return dateFormatter.stringFromDate(NSDate())
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: GameTableViewCell = tableView.dequeueReusableCellWithIdentifier("GamesListCell", forIndexPath: indexPath) as! GameTableViewCell
    
        // Configure the custom cell with game info
        let gameInfo = gamesList[indexPath.row] as! GamesCalendar
        cell.setContentFromGameInfo(gameInfo)

        return cell
    }

    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: GameTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! GameTableViewCell
        
        let doublePair: DoublePair = DoublePair.sharedInstance
        doublePair.topTimeline = cell.hostTwitTimeLine
        doublePair.bottomTimeline = cell.guestTwitTimeLine
        
        cell.setSelected(false, animated: true)
        
        // Send a notification about new game selection (DoubletPair update)
        NSNotificationCenter.defaultCenter().postNotificationName("DoubletPairWasChanged", object: nil)
        
        // Hiding the menu
        self.closeRight()
    }
    
    // MARK: Actions
    
    /**
    Opening KHL Games calendar in Safari
    */
    @IBAction func openKHLCalendar(sender: AnyObject) {
        if let url = NSURL(string: NSLoc("common.khl.calendar")) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
