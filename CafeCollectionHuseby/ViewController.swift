//
//  ViewController.swift
//  CafeCollectionHuseby
//
//  Created by DANIEL HUSEBY on 9/5/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var items: [String] = ["Bananas", "Apples", "Oranges", "Ice Cream", "Cupcake"]
    var prices: [Double] = [0.19, 0.09, 0.14, 0.99, 0.49]
    var userStuff: [String:Int] = [:]
    // sorting methods: 0 = normal, 1 = name, 2 = price
    var sortingMethod = 0
    // apparently not a stretch anymore ^^^
    var adminPassword = "yummyBan4nas3"
    var developerMode = false;
    
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var menuOutlet: UITextView!
    @IBOutlet weak var adminButtonOutlet: UIButton!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    @IBOutlet weak var cartOutlet: UITextView!
    
    @IBOutlet weak var itemNameOutlet: UITextField!
    @IBOutlet weak var quantityOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityOutlet.delegate = self
        itemNameOutlet.delegate = self
        // Do any additional setup after loading the view.
        buttonOutlet.layer.cornerRadius = 10;
        adminButtonOutlet.layer.cornerRadius = 10;
        deleteButtonOutlet.layer.cornerRadius = 10;
        deleteButtonOutlet.isHidden = true;
        updateInfo()
    }
    func createAlert(alertTitle: String, alertDesc: String){
        let alert = UIAlertController(title: alertTitle, message: alertDesc, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    
    func updateInfo(){
        menuOutlet.text = "Menu items:"
        if sortingMethod == 0{
            for i in 0..<items.count {
                menuOutlet.text += "\n" + items[i] + ": $\(floor(100*prices[i])/100.00)"
            }
        }
        cartOutlet.text = ""
        var totalPrice = 0.0
        for (itemName, quantity) in userStuff{
            // if it doesn't appear, an admin probably removed the item, so don't bother showing it
            if let index = items.firstIndex(of: itemName){
                var price = prices[index]*Double(quantity)
                totalPrice += price
                cartOutlet.text += "\n" + itemName + "(\(quantity)): $\(floor(100*price)/100.00)"
            }
        }
        cartOutlet.text = "Your cart: Costs $\(floor(100*totalPrice)/100.00)\n"+cartOutlet.text
    }
    
    
    @IBAction func adminAction(_ sender: Any) {
        itemNameOutlet.resignFirstResponder()
        quantityOutlet.resignFirstResponder()
        var itemName = itemNameOutlet.text!
        if(developerMode){
            titleOutlet.text = "Cafe Mini App"
            deleteButtonOutlet.isHidden = true
            quantityOutlet.placeholder = "Type Quantity Here"
            developerMode = false
            updateInfo()
            return
        }
        if (itemName==adminPassword){
            clearTextFields()
            titleOutlet.text = "Developer Mode"
            deleteButtonOutlet.isHidden = false
            quantityOutlet.placeholder = "Type Price Here"
            developerMode = true
            updateInfo()
        }
    }
    
    func clearTextFields(){
        itemNameOutlet.text = ""; quantityOutlet.text = ""
    }
    
    @IBAction func addItemAction(_ sender: UIButton) {
        itemNameOutlet.resignFirstResponder()
        quantityOutlet.resignFirstResponder()
        if(developerMode){
            var itemName = itemNameOutlet.text!
            if let huh = items.firstIndex(of: itemName){
                createAlert(alertTitle: "Already in menu", alertDesc: "That item is already put in your menu")
                clearTextFields()
                return
            }
            if let price = Double(quantityOutlet.text!){
                if price > 0.0{
                    // this is the stuff that will work
                    items.append(itemName)
                    prices.append(price)
                    updateInfo()
                }else{
                    createAlert(alertTitle: "Not a valid number", alertDesc: "Type in a valid number")
                }
                
            }else{
                createAlert(alertTitle: "Not a valid number", alertDesc: "Type in a valid number")
            }
            clearTextFields()
            return
            
        }
        var itemName = itemNameOutlet.text!
        if let itemPosition = items.firstIndex(of: itemName){
            if let huh = userStuff[itemName]{
                createAlert(alertTitle: "Already in cart", alertDesc: "You already put that in your cart")
            }else{
                if let quantity = Int(quantityOutlet.text!){
                    if quantity > 0{
                        // this is the stuff that will work
                        userStuff[itemName] = quantity
                        updateInfo()
                    }else{
                        createAlert(alertTitle: "Not a valid number", alertDesc: "Type in a valid number")
                    }
                    
                }else{
                    createAlert(alertTitle: "Not a valid number", alertDesc: "Type in a valid number")
                }
            }
            
        }else{
            createAlert(alertTitle: "That is not a valid item", alertDesc: "Type in the correct name")
        }
        clearTextFields()
    }
    
    @IBAction func deleteOutlet(_ sender: Any) {
        itemNameOutlet.resignFirstResponder()
        quantityOutlet.resignFirstResponder()
        if(developerMode){
            // just making sure
            var itemName = itemNameOutlet.text!
            if let itemPosition = items.firstIndex(of: itemName){
                items.remove(at: itemPosition)
                prices.remove(at: itemPosition)
            }else{
                createAlert(alertTitle: "That is not a valid item", alertDesc: "Type in the correct name")
            }
            clearTextFields()
            updateInfo()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

}

