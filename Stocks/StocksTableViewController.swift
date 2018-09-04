//
//  StocksTableViewController.swift
//  Stocks
//
//  Created by Neo Ighodaro on 03/09/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit
import Alamofire
import PusherSwift
import PushNotifications
import NotificationBannerSwift

class StocksTableViewController: UITableViewController {
    
    var stocks: [Stock] = []
    
    var pusher: Pusher!
    let pushNotifications = PushNotifications.shared
    let notificationSettings = STNotificationSettings.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStockPrices()
        
        tableView.separatorInset.left = 0
        tableView.backgroundColor = UIColor.black
        
        let customCell = UINib(nibName: "StockCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "stock")
        
        pusher = Pusher(
            key: AppConstants.PUSHER_APP_KEY,
            options: PusherClientOptions(host: .cluster(AppConstants.PUSHER_APP_CLUSTER))
        )
        
        let channel = pusher.subscribe("stocks")
        let _ = channel.bind(eventName: "update") { [unowned self] data in
            if let data = data as? [[String: AnyObject]] {
                if let encoded = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                    if let stocks = try? JSONDecoder().decode([Stock].self, from: encoded) {
                        self.stocks = stocks
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        pusher.connect()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stock", for: indexPath) as! StockCell
        cell.stock = stocks[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StockCell
        if let stock = cell.stock {
            showNotificationSettingAlert(for: stock)
        }
    }
    

    private func fetchStockPrices() {
        Alamofire.request(AppConstants.ENDPOINT + "/stocks")
            .validate()
            .responseJSON { [unowned self] resp in
                guard let data = resp.data, resp.result.isSuccess else {
                    let msg = "Error fetching prices"
                    return StatusBarNotificationBanner(title: msg, style: .danger).show()
                }
                
                if let stocks = try? JSONDecoder().decode([Stock].self, from: data) {
                    self.stocks = stocks
                    self.tableView.reloadData()
                }
            }
    }

    private func showNotificationSettingAlert(for stock: Stock) {
        let enabled = notificationSettings.enabled(for: stock.name)
        let title = "Notification settings"
        let message = "Change the notification settings for this stock. What would you like to do?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let onTitle = enabled ? "Keep on" : "Turn on notifications"
        alert.addAction(UIAlertAction(title: onTitle, style: .default) { [unowned self] action in
            guard enabled == false else { return }
            self.notificationSettings.save(stock: stock.name, enabled: true)
            
            let feedback = "Notfications turned on for \(stock.name)"
            StatusBarNotificationBanner(title: feedback, style: .success).show()

            try? self.pushNotifications.subscribe(interest: stock.name.uppercased())
        })
        
        let offTitle = enabled ? "Turn off notifications" : "Leave off"
        let offStyle: UIAlertActionStyle = enabled ? .destructive : .cancel
        alert.addAction(UIAlertAction(title: offTitle, style: offStyle) { [unowned self] action in
            guard enabled else { return }
            self.notificationSettings.save(stock: stock.name, enabled: false)
            
            let feedback = "Notfications turned off for \(stock.name)"
            StatusBarNotificationBanner(title: feedback, style: .success).show()
            
            try? self.pushNotifications.unsubscribe(interest: stock.name.uppercased())
        })
        
        present(alert, animated: true, completion: nil)
    }
}
