//
//  Slider.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 19/02/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class Slider: UISlider {
    
    var TrackingSlider:UISlider = UISlider()
    let timeLabel = UILabel()
    
    override func awakeFromNib() {
        print("awake from nib for slider")
        self.superview?.addSubview(createTimeLabel())
        timeLabel.superview?.bringSubview(toFront: timeLabel)
    }
   

    @IBInspectable var trackHeight: CGFloat = 20.0
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin:bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
    func convertTime(_ time: TimeInterval) -> NSString {
        let duration = Int(time)
        let seconds = (duration % 60)
        let minutes = (duration / 60) % 60
        let final = NSString(format:"%0.2d:%0.2d", minutes,seconds)
        return final
    }
    
    func setupSlider(TotalTime: Float, TrackingSlide: UISlider, view: UIView){
        TrackingSlider = TrackingSlide
        TrackingSlider.maximumValue = TotalTime
        var totalTime = Int(TotalTime)
        //--MARK--fix for 1 minute instead of 60 sec.
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
                if self.TrackingSlider.maximumValue != self.TrackingSlider.value{
                    self.TrackingSlider.value = self.TrackingSlider.value + 1.0
                    print(self.TrackingSlider.value)
                    var newTime = 0
                    
                    newTime = (Int(totalTime) - 1)/60
                    totalTime -= 1
                    self.timeLabel.text = "\(newTime) min"
                    print("total time \(totalTime, TotalTime)")
                }
                
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func createTimeLabel() -> UILabel{
        //let center = currenttimeFrame.origin.x + currenttimeFrame.width/2
        //timeLabel.center = CGPoint(x: 20, y: 20)
        timeLabel.text = "Waiting For Driver"
        timeLabel.font = UIFont(name: "Courier new", size: 14)
        timeLabel.textColor = UIColor.white
        timeLabel.alpha = 0.8
        timeLabel.tag = 10
        let _trackRect = trackRect(forBounds: TrackingSlider.bounds)
        
        let center = TrackingSlider.frame.width/2
        
        let currenttimeFrame = thumbRect(forBounds: TrackingSlider.bounds, trackRect:_trackRect, value: value)
        timeLabel.frame = CGRect(x: currenttimeFrame.origin.x + center + 60, y: currenttimeFrame.origin.y + 5, width: 200, height: 20)

        return timeLabel

    }
    
    
    
}
