//
//  KisiEkleViewController.swift
//  KisilerApp
//
//  Created by Ebrar Levent on 18.01.2024.
//

import UIKit

class KisiEkleViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var kisiAdTextField: UITextField!
    
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    @IBAction func ekle(_ sender: Any) {
        
        if let ad = kisiAdTextField.text, let tel = kisiTelTextField.text {
            //Bu nesne ile veritabanina erismis olacagim
            let kisi = Kisiler(context: context)
            kisi.kisiAd = ad
            kisi.kisiTel = tel
            //kayit etme:
            appDelegate.saveContext()
        }
    }
    
    
}
