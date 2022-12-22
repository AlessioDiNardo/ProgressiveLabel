//
//  ViewController.swift
//  progressive-label
//
//  Created by Alessio Di Nardo on 05/05/22.
//

import UIKit

class ViewController: UIViewController {
    
    let myProgressView = MyProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let restartButton = UIButton(frame: CGRect(x: view.frame.width/2, y: view.frame.width/2, width: 100, height: 50))
        view.backgroundColor = .black
               
        restartButton.setTitle("RESTART", for: .normal)
        restartButton.backgroundColor = .red
        restartButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        restartButton.layer.borderWidth = 3
        restartButton.layer.cornerRadius = 20
        //restartButton.center = view.center
        
        myProgressView.center = view.center
        myProgressView.layer.borderColor = UIColor.white.cgColor
        myProgressView.layer.borderWidth = 3
        myProgressView.layer.cornerRadius = myProgressView.frame.height / 2
        myProgressView.clipsToBounds = true
        myProgressView.progressColor = .red
        myProgressView.progressMax = 1
        
        view.addSubview(myProgressView)
        view.addSubview(restartButton)

        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(addProgress), userInfo: nil, repeats: true)
    }

    @objc func addProgress() {
        if myProgressView.progress < 1 {
            myProgressView.progress += 0.05
        } else {
            timer.invalidate()
        }
    }
    
    @objc func buttonAction() {
        myProgressView.progress = 0
        if timer.isValid {
            return
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(addProgress), userInfo: nil, repeats: true)
        }
    }

}


class MyProgressView: UIView {
    
    var progressColor = UIColor(red: 108/255, green: 200/255, blue: 226/255, alpha: 1) //default progress color
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var progressMax: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        //Setup variables for getting progress for drawing
        let size = bounds.size
        let foregroundColor = UIColor.white
        let font = UIFont.boldSystemFont(ofSize: 25)
        
        let progress = NSString(format: "$%d", Int(round(self.progress * 100)))
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        let textSize = progress.size(withAttributes: attributes)
        let progressX = ceil(self.progress * size.width)
        let textPoint = CGPoint(x: 10, y: ceil((size.height - textSize.height) / 2))
        
        let secondProgress = NSString(format: "$%d", Int(round(self.progressMax * 100)))
        let secondTextSize = secondProgress.size(withAttributes: attributes)
        let secondTextPoint = CGPoint(x: (self.bounds.width - secondTextSize.width) - 10, y: ceil((size.height - secondTextSize.height) / 2))
        
        progressColor.setFill()
        context?.fill(bounds)
        attributes[.foregroundColor] = foregroundColor
        progress.draw(at: textPoint, withAttributes: attributes)
        secondProgress.draw(at: secondTextPoint, withAttributes: attributes)
        
        context?.saveGState()
        let remainingProgressRect = CGRect(x: progressX, y: 0, width: size.width, height: size.height)
        context?.addRect(remainingProgressRect)
        context?.clip()
        
        foregroundColor.setFill()
        context?.fill(bounds)
        attributes[.foregroundColor] = progressColor
        progress.draw(at: textPoint, withAttributes: attributes)
        secondProgress.draw(at: secondTextPoint, withAttributes: attributes)
        
        context?.restoreGState()
    }
}
