//
//  DetailsViewController.swift
//  ATMLocator
//
//  Created by Aparna Revu on 3/5/17.
//  Copyright © 2017 Aparna Revu. All rights reserved.
//

import UIKit

extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}


class DetailsViewController: UITableViewController {

    var selectedATM:ATMInfo!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var addressLabel:UILabel!
    @IBOutlet weak var phoneLabel:UILabel!
    @IBOutlet weak var distanceLabel:UILabel!

    @IBOutlet weak var lobbyDetailsView:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Branch Details"
        
        self.titleLabel.text = selectedATM.name
        self.addressLabel.text = selectedATM.addressDetails()
        self.phoneLabel.text = selectedATM.phone?.toPhoneNumber()
        //self.lobbyDetailsView.text = selectedATM.
        self.distanceLabel.text = String(describing: selectedATM.distance)
        let daysList = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday" ,"Saturday"]
        
        var flag = 0
        var hoursDetails:String = ""
        for hoursDictonary in selectedATM.lobbyHours as! [AnyObject] {
            if let hoursData = hoursDictonary as? String {
                if(hoursData.characters.count > 0){
                    hoursDetails = hoursDetails + "\n" + daysList[flag] + " : " + hoursData
                }
            }
            flag += 1
        }
        
        DispatchQueue.main.async {
            self.lobbyDetailsView.text = hoursDetails.characters.count > 0 ? hoursDetails : "No Data available"
        }

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 3
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 40.0
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
