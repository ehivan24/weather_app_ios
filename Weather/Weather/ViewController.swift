//
//  ViewController.swift
//  Weather
//
//  Created by edwing santos on 12/13/18.
//  Copyright © 2018 edwing santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mLocationLabel: UILabel!
    @IBOutlet weak var mDayOfWeekLabel: UILabel!
    @IBOutlet weak var mConditionImageView: UIImageView!
    @IBOutlet weak var mConditionLabel: UILabel!
    @IBOutlet weak var mConditionDegreesLabel: UILabel!
    @IBOutlet weak var mBackgroundView: UIView!
    
    let mGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mBackgroundView.layer.addSublayer(mGradientLayer)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViewBackground(redTopColor: BlueBackgroundView.redTopColor,
                          greenTopColor: BlueBackgroundView.greenTopColor,
                          blueTopColor: BlueBackgroundView.blueTopColor,
                          redBottomColor: BlueBackgroundView.redBottomColor,
                          greenBottomColor: BlueBackgroundView.blueBottomColor,
                          blueBottomColor: BlueBackgroundView.blueBottomColor, darkBackground: false)
    }
    
    func setViewBackground(redTopColor: Float, greenTopColor: Float, blueTopColor: Float,
                           redBottomColor: Float, greenBottomColor: Float, blueBottomColor: Float, darkBackground: Bool) {
        var bottomViewColor: CGColor!
        var topViewColor: CGColor!

        if darkBackground {
            topViewColor = UIColor(red: CGFloat(redTopColor / 255.0),
                                   green: CGFloat(greenTopColor / 255.0),
                                   blue: CGFloat(blueTopColor / 255.0),
                                   alpha: 1.0).cgColor
        } else {
            topViewColor = UIColor(red: CGFloat(redTopColor / 255.0),
                                   green: CGFloat(greenTopColor / 255.0),
                                   blue: CGFloat(blueTopColor),
                                   alpha: 1.0).cgColor
        }
        
        bottomViewColor = UIColor(red: CGFloat(redBottomColor / 255.0),
                                      green: CGFloat(redBottomColor / 255.0),
                                      blue: CGFloat(redBottomColor / 255.0), alpha: 1.0).cgColor
        
        mGradientLayer.frame = view.bounds
        mGradientLayer.colors = [topViewColor, bottomViewColor]
    }
}

