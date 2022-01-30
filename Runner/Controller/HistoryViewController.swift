//
//  HistoryViewController.swift
//  Runner
//
//  Created by Vahit Emre TELLİER on 19.01.2022.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? RunHistoryCell {
            guard let run = RunModel.getAllRunHistory()?[indexPath.row] else {
                return RunHistoryCell()
            }
            
            cell.setView(runModel: run)
            return cell
        } else {
            return RunHistoryCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RunModel.getAllRunHistory()?.count ?? 0
    }
    
//    cell uzunluğunu ayarlandı
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }


}
