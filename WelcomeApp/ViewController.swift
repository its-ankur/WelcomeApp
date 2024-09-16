//
//  ViewController.swift
//  WelcomeApp
//
//  Created by Ankur on 12/09/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ContinueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundCorners(button: ContinueButton, corners: [.topLeft, .bottomLeft], radius: 20)
    }


    // Function to round specific corners
    func roundCorners(button: UIButton, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: button.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        button.layer.mask = mask
    }

  
    @IBAction func btnTapped(_ sender: Any) {
        
        print("Continue button clicked")
        let storyboard=self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
}

