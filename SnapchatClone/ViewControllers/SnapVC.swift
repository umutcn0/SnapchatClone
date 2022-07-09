//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Umut Can on 9.07.2022.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {
    

    @IBOutlet weak var timeLabel: UILabel!
    var selectedSnap : Snap?
    var inputArray = [AlamofireSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snap = selectedSnap {
                    
            timeLabel.text = "Time Left: \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(AlamofireSource(urlString: imageUrl)!)
            }
            print(inputArray)
            
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.black
            pageIndicator.pageIndicatorTintColor = UIColor.lightGray
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
            
        }

    }
    


}
