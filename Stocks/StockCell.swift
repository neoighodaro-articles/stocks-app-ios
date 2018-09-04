//
//  StockCell.swift
//  Stocks
//
//  Created by Neo Ighodaro on 03/09/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit

struct Stock: Codable {
    let name: String
    let price: Float
    let percentage: String
}

class StockCell: UITableViewCell {

    var stock: Stock? {
        didSet {
            if let stock = stock {
                stockName.text = stock.name
                stockPrice.text = "\(stock.price)"
                stockPercentageChange.text = "\(stock.percentage)"
                percentageWrapper.backgroundColor = stock.percentage.first == "+"
                    ? UIColor.green.withAlphaComponent(0.7)
                    : UIColor.red
            }
        }
    }
    
    @IBOutlet private weak var stockName: UILabel!
    @IBOutlet private weak var stockPrice: UILabel!
    @IBOutlet private weak var percentageWrapper: UIView!
    @IBOutlet private weak var stockPercentageChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        percentageWrapper.layer.cornerRadius = 5
    }
}
