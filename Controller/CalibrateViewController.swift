//
//  CalibrateViewController.swift
//  FACS-Recorder
//
//  Created by 권영진 on 05/12/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import ARKit

class CalibrateViewController: UIViewController {

    var progressCircle: JKActivityIndicator!
    
    deinit {
        print("Deallocate Calibrate ViewController.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildActivityIndicator()
        buildGoBackButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        // delay a bit until we get a face data from ARKit
        perform(#selector(checkReadyToBuildView), with: nil, afterDelay: 1.0, inModes: [.common])
        progressCircle.animate(duration: 1)
    }
    func buildActivityIndicator(){
        
        progressCircle = JKActivityIndicator(radius: 100, lineWidth: 10)
        progressCircle.setParent(self.view)
        
    }
    func buildGoBackButton() {
        let goBackButt = JKImageButton("left.normal.png", width: 48, height: 48, borderWidth: 2, bgColor: JKColor(0, 0, 0, 0.2).as8BitToUiColor())
        goBackButt.imageEdgeInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 12)
        goBackButt.attachToParent(self.view, .lowerLeft, padX: 12, padY: 12)
        goBackButt.addTarget(self, action: #selector(goBackButtonPressed(_:)), for: .touchUpInside)
    }
    @objc func goBackButtonPressed(_ sender: Any) {

        let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        hapticGenerator.prepare()
        hapticGenerator.impactOccurred()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func checkReadyToBuildView() {
        // Remove activity indicator
        progressCircle.removeFromSuperview()

        // Do any additional setup after loading the view.
        if gFaceCalibrated != nil {
            buildCalibratedResultView()
        }
        else {
            print("Calibrated result is not ready yet.")
            progressCircle.animate(duration: 1)
        }
    }
    
    func buildCalibratedResultView() {
        let nameFontSize: CGFloat = 17
        let valueFontSiza: CGFloat  = 18
        let nameWidth: CGFloat  = 170
        let valueWidth: CGFloat  = 70
        let rowHeight: CGFloat  = 40
        let rowSpacing: CGFloat = 20
        
        let scrollView = UIScrollView()
        let vertStack = JKStackColumn(spacing: rowSpacing, distribution: .fillEqually)

        // Clean up values
        for target in gFaceCalibrated.blendShape {
            let value = round(Double(truncating: target.value) * 1000.0) / 1000.0
            if value > gSmallestValue {
                gFaceCalibrated.blendShape[target.key] = NSNumber(value: value)
            } else {
                gFaceCalibrated.blendShape[target.key] = NSNumber(value: 0.0)
            }
        }
        // Sort the dictionary by values decrementing
        let sortedDic = gFaceCalibrated.blendShape.sorted(){ $0.value.doubleValue > $1.value.doubleValue }
        for target in sortedDic{
            
            let nameLabel = JKLabel()
            nameLabel.initialize(labelText: target.key.rawValue, fontSize: nameFontSize, fontWeight: .bold)
            nameLabel.setIntrinsicSize(width: nameWidth, height: rowHeight)
            nameLabel.textColor = UIColor.lightText
            //nameLabel.backgroundColor = UIColor.black
            
            let valueLabel = JKLabel()
            let valueString = String(format: "%.3f", target.value.doubleValue)
            valueLabel.initialize(labelText: valueString, fontSize: valueFontSiza, fontWeight: .bold)
            valueLabel.setIntrinsicSize(width: valueWidth, height: rowHeight)
            valueLabel.textAlignment = .left
            valueLabel.textColor = getCalibratedValueColor(target.value.doubleValue)
            //valueLabel.backgroundColor = UIColor.black

            let rowStack = JKStackRow([nameLabel,valueLabel], spacing: 12, distribution: .fillProportionally)
            vertStack.addArrangedSubview(rowStack)
        }
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(vertStack)
        NSLayoutConstraint.activate([
            vertStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            //vertStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0),
            vertStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 4),
            vertStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
            ])
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        //scrollView.backgroundColor = UIColor.darkGray
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 60),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
            ])
    }
    func getCalibratedValueColor(_ value: Double) -> UIColor {

        let saturation = easeOutCubic(value)
        //print("saturation  \(saturation)")
        let resultColor = UIColor(hue: 0, saturation: CGFloat(saturation), brightness: 0.85, alpha: 1)
        return resultColor
    }
//    func easeOutQuadratic(_ x: Double) -> Double {
//        return -x * (x - 2)
//    }
    func easeOutCubic(_ x: Double) -> Double {
        let p = x - 1
        return p * p * p + 1
    }

}
