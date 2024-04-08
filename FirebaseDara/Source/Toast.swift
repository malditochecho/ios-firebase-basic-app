//
//  Toast.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-29.
//

import UIKit

class Toast: UIAlertController {
    static func show( view : UIViewController, title : String, message : String, delay: Int) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert );
        view.present(alert, animated: true);
        let deadlineTime = DispatchTime.now() + .seconds(delay);
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            alert.dismiss(animated: true, completion: nil);
        })
    }
    
    static func ok ( view : UIViewController, title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        view.present(alert, animated: true)
    }
}
