//
//  LeftMenuViewController.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 22/09/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit

/// Part of the application's navigation - left menu view controller (based on SlideMenuControllerSwift lib). Presenting list of main app's screens

enum LeftMenu: Int {
    case Home = 0
    case Teams
    case About
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var menus = [NSLoc("menu.left.home"), NSLoc("menu.left.teams"), NSLoc("menu.left.about")]
    var mainViewController: UIViewController!
    var teamsViewController: UIViewController!
    var aboutViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let teamsViewController = storyboard.instantiateViewControllerWithIdentifier("TeamsViewController") as! TeamsViewController
        self.teamsViewController = UINavigationController(rootViewController: teamsViewController)
        let aboutViewController = storyboard.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
        self.aboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSource&Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
        cell.backgroundColor = UIColor(red: 64/255, green: 170/255, blue: 239/255, alpha: 1.0)
        cell.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        cell.textLabel?.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        cell.textLabel?.text = menus[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Home:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            break
        case .Teams:
            self.slideMenuController()?.changeMainViewController(self.teamsViewController, close: true)
            break
        case .About:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
        }
    }

}
