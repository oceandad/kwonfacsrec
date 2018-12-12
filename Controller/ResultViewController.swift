//
//  ResultViewController.swift
//  FACS-Recorder
//
//  Created by 권영진 on 20/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    
    var fileName:String = ""
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupDescription: UILabel!
    @IBOutlet weak var goFileNameButton: UIButton!
    @IBOutlet weak var goRetakeButton: UIButton!
    
    deinit {
        print("Deallocate Result View Controller.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // round corners
        popupView.layer.cornerRadius = 6
        goFileNameButton.layer.cornerRadius = 4
        goRetakeButton.layer.cornerRadius = 4
        // fill labels
        popupTitle.text = "Success"
        popupDescription.text = "Finished writing the captured data \nfile name as \n\""+fileName+".lml\""
        popupDescription.lineBreakMode = .byWordWrapping
        popupDescription.numberOfLines = 3
    }
    
    @IBAction func newRecordingButtonPressed(_ sender: Any) {
        let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        hapticGenerator.prepare()
        hapticGenerator.impactOccurred()
        
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func retakeButtonPressed(_ sender: Any) {
        let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        hapticGenerator.prepare()
        hapticGenerator.impactOccurred()
        
        self.view.removeFromSuperview()
        // to close super view
        //self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
