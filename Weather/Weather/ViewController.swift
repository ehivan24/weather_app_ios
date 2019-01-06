//
//  ViewController.swift
//  Weather
//
//  Created by edwing santos on 12/13/18.
//  Copyright © 2018 edwing santos. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let LOG_TAG: String = "MAIN_VIEW"

    @IBOutlet weak var mLocationLabel: UILabel!
    @IBOutlet weak var mDayOfWeekLabel: UILabel!
    @IBOutlet weak var mConditionImageView: UIImageView!
    @IBOutlet weak var mConditionLabel: UILabel!
    @IBOutlet weak var mConditionDegreesLabel: UILabel!
    @IBOutlet weak var mBackgroundView: UIView!
    
    let mGradientLayer = CAGradientLayer()
    let mWhiteColorCode: Float = 255.0
    var activityIndicator: NVActivityIndicatorView!
    let locationManager =  CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mBackgroundView.layer.addSublayer(mGradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x:(view.frame.width - indicatorSize) / 2,
                                    y:(view.frame.height) / 2, width: indicatorSize , height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0 )
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        activityIndicator.startAnimating()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        AppSettings.INITIAL_LAT = location.coordinate.latitude
        AppSettings.INITIAL_LON = location.coordinate.longitude
        AppSettings.logDebug(label: self.LOG_TAG, anyObject: AppSettings.INITIAL_LAT)
        AppSettings.logDebug(label: self.LOG_TAG, anyObject: AppSettings.INITIAL_LON)
        let weatherAPIURL = AppSettings.getOpenWeatherApiUrl(lat: AppSettings.INITIAL_LAT, lon: AppSettings.INITIAL_LON)
        AppSettings.logDebug(label: self.LOG_TAG, anyObject: weatherAPIURL)
        Alamofire.request(weatherAPIURL).responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                //AppSettings.logDebug(label: self.LOG_TAG, anyObject: jsonResponse)
                let jsonWeather = jsonResponse["weather"].array![0]
                AppSettings.logDebug(label: self.LOG_TAG, anyObject: jsonWeather)
                let jsonTemp = jsonResponse["main"]
                AppSettings.logDebug(label: self.LOG_TAG, anyObject: jsonTemp)
                let iconName = jsonWeather["icon"].stringValue
                AppSettings.logDebug(label: self.LOG_TAG, anyObject: iconName)
                
                self.mLocationLabel.text = jsonResponse["name"].stringValue
                self.mConditionImageView.image = UIImage(named: iconName)
                self.mConditionLabel.text = jsonWeather["main"].stringValue
                self.mConditionDegreesLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))℃"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                AppSettings.logDebug(label: self.LOG_TAG, anyObject: date)
                self.mDayOfWeekLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                AppSettings.logDebug(label: self.LOG_TAG, anyObject: suffix)
                self.updateBackgroundColorBased(suffixTime: suffix)
            }
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func setViewBackground(redTopColor: Float, greenTopColor: Float, blueTopColor: Float,
                           redBottomColor: Float, greenBottomColor: Float, blueBottomColor: Float, darkBackground: Bool) {
        var bottomViewColor: CGColor!
        var topViewColor: CGColor!

        if darkBackground {
            topViewColor = UIColor(red: CGFloat(redTopColor / mWhiteColorCode),
                                   green: CGFloat(greenTopColor / mWhiteColorCode),
                                   blue: CGFloat(blueTopColor / mWhiteColorCode),
                                   alpha: 1.0).cgColor
        } else {
            topViewColor = UIColor(red: CGFloat(redTopColor / mWhiteColorCode),
                                   green: CGFloat(greenTopColor / mWhiteColorCode),
                                   blue: CGFloat(blueTopColor),
                                   alpha: 1.0).cgColor
        }
        
        bottomViewColor = UIColor(red: CGFloat(redBottomColor / mWhiteColorCode),
                                      green: CGFloat(redBottomColor / mWhiteColorCode),
                                      blue: CGFloat(redBottomColor / mWhiteColorCode),
                                      alpha: 1.0).cgColor
        
        mGradientLayer.frame = view.bounds
        mGradientLayer.colors = [topViewColor, bottomViewColor]
    }
    
    func updateBackgroundColorBased(suffixTime: Substring){
        if(suffixTime == "n"){
            self.setViewBackground(redTopColor: BlackBackgroundView.redTopColor,
                                   greenTopColor: BlackBackgroundView.greenTopColor,
                                   blueTopColor: BlackBackgroundView.blueTopColor,
                                   redBottomColor: BlackBackgroundView.redBottomColor,
                                   greenBottomColor: BlackBackgroundView.blueBottomColor,
                                   blueBottomColor: BlackBackgroundView.blueBottomColor,
                                   darkBackground: true)
            
        } else {
            // must be day time
            self.setViewBackground(redTopColor: BlueBackgroundView.redTopColor,
                                   greenTopColor: BlueBackgroundView.greenTopColor,
                                   blueTopColor: BlueBackgroundView.blueTopColor,
                                   redBottomColor: BlueBackgroundView.redBottomColor,
                                   greenBottomColor: BlueBackgroundView.blueBottomColor,
                                   blueBottomColor: BlueBackgroundView.blueBottomColor,
                                   darkBackground: false)
        }
    }
}

