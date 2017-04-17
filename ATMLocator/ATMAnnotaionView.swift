//
//  ATMAnnotaionView.swift
//  ATMLocator
//
//  Created by Divya Tatavarthi on 3/5/17.
//  Copyright © 2017 Aparna Revu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ATMAnnotaionView : MKPinAnnotationView
{
    let selectedLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 140, height: 38))
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)
        
        if(selected)
        {
            // Do customization, for example:
            selectedLabel.text = "Hello World!!"
            selectedLabel.textAlignment = .center
            selectedLabel.font = UIFont.init(name: "HelveticaBold", size: 15)
            selectedLabel.backgroundColor = UIColor.brown
            selectedLabel.layer.borderColor = UIColor.darkGray.cgColor
            selectedLabel.layer.borderWidth = 2
            selectedLabel.layer.cornerRadius = 5
            selectedLabel.layer.masksToBounds = true
            
            selectedLabel.center.x = 0.5 * self.frame.size.width;
            selectedLabel.center.y = -0.5 * selectedLabel.frame.height;
            self.addSubview(selectedLabel)
        }
        else
        {
            selectedLabel.removeFromSuperview()
        }
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        mapView?.selectAnnotation(self.annotation!, animated: true)
//    }

}    
