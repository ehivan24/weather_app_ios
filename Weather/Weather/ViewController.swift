//
//  ViewController.swift
//  Weather
//
//  Created by edwing santos on 12/13/18.
//  Copyright © 2018 edwing santos. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mLocationLabel: UILabel!
    @IBOutlet weak var mDayOfWeekLabel: UILabel!
    @IBOutlet weak var mConditionImageView: UIImageView!
    @IBOutlet weak var mConditionLabel: UILabel!
    @IBOutlet weak var mConditionDegreesLabel: UILabel!
    @IBOutlet weak var mBackgroundView: UIView!
    
    let mGradientLayer = CAGradientLayer()
    let mWhiteColorCode: Float = 255.0
    var activityNavigator: NVActivityIndicatorView!
    let locationManager =  CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mBackgroundView.layer.addSublayer(mGradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x:(view.frame.width - indicatorSize)/2,
                                    y:(view.frame.height)/2, width: indicatorSize , height: indicatorSize)
        activityNavigator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0 )
        activityNavigator.backgroundColor = UIColor.black
        view.addSubview(activityNavigator)
        
        locationManager.requestWhenInUseAuthorization()
        activityNavigator.startAnimating()
        
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
        print(AppSettings.INITIAL_LAT)
        print(AppSettings.INITIAL_LON)
        let weatherAPIURL = AppSettings.getOpenWeatherApiUrl(lat: AppSettings.INITIAL_LAT, lon: AppSettings.INITIAL_LON)
        print(weatherAPIURL)
        Alamofire.request(weatherAPIURL).responseJSON{
            response in
            self.activityNavigator.stopAnimating()
            
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                print(jsonResponse)
                let jsonWeather = jsonResponse["weather"].array![0]
                
            }
        }
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
                                      blue: CGFloat(redBottomColor / mWhiteColorCode), alpha: 1.0).cgColor
        
        mGradientLayer.frame = view.bounds
        mGradientLayer.colors = [topViewColor, bottomViewColor]
    }
}

