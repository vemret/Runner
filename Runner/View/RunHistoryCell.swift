//
//  RunHistoryCell.swift
//  Runner
//
//  Created by Vahit Emre TELLİER on 24.01.2022.
//

import UIKit

class RunHistoryCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setView(runModel : RunModel) {
        timeLabel.text = runModel.time.counterToSecond()
        distanceLabel.text = String(format: "%.2f", runModel.distance/1000)
        paceLabel.text = runModel.pace.counterToSecond()
        dateLabel.text = "\(runModel.date.getDate())"
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
