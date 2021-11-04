//
//  PlaceServiceTestController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 04/11/21.
//

import CoreData
import UIKit

class PlaceServiceTestController: UIViewController {
    
    @IBOutlet weak var createInput: UITextInput!
    @IBOutlet weak var retrieveInput: UITextInput!
    @IBOutlet weak var updateInput: UITextInput!
    @IBOutlet weak var deleteInput: UITextInput!
    
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var retrieveBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    let service = PlaceService()
    var uid: UUID? = nil
    
    @IBAction func btnCreate(_ sender: UIButton) {
        do {
            uid = try service.create(name: "teste", latitude: 34, longitude: 43)
            print(uid?.uuidString)
        } catch {
            print("nao criou, deu ruim")
        }
    }
    @IBAction func btnRetrieve(_ sender: UIButton) {
        let lugar = try! service.read(uid: uid!)
        print(lugar?.name)
    }
    @IBAction func btnUpdate(_ sender: UIButton) {
        
    }
    @IBAction func btnDelete(_ sender: UIButton) {
        try! service.delete(uid: uid!)
    }
    
}
