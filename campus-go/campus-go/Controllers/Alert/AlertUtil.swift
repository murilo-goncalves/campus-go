//
//  AlertUtil.swift
//  campus-go
//
//  Created by Giordano Mattiello on 25/11/21.
//

import Foundation
import UIKit

struct AlertUtil{
    
    func showAlert(viewController: AlertViewDelegate,place: Place?){
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        if let myAlert = storyboard.instantiateViewController(withIdentifier: "Alert") as? AlertViewController{
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            if let place_ = place{
                myAlert.place = place_
            }
            myAlert.delegate = viewController
            viewController.present(myAlert, animated: true, completion: nil)
        }
    }
}
