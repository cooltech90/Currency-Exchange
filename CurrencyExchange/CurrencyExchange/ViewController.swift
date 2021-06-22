//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Lourdes Zekkani on 6/14/21.
//

import UIKit
import AYPopupPickerView

class ViewController: UIViewController {
    var myCurrency: [String] = []
    var myCurrencyInput: [String] = []
    var currencyInputTag = "USD"
    var myValue: [Double] = []
    var myValueInput: [Double] = []
    var activeCurrency:Double = 0;
    var activeCurrencyInput:Double = 0;
    
    
    @IBOutlet var input: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        exchangeRateAPI()
    }
    
    
    @IBAction func getStartingCurrency(_ sender: UIButton) {
        let popupPickerView = AYPopupPickerView()
        //popupPickerView.pickerView.backgroundColor = UIColor.systemBackground
        popupPickerView.display(itemTitles: myCurrencyInput, doneHandler: {
            let selectedIndex = popupPickerView.pickerView.selectedRow(inComponent: 0)
            sender.setTitle(self.myCurrencyInput[selectedIndex], for: .normal)
            self.currencyInputTag = self.myCurrencyInput[selectedIndex]
            
            self.exchangeRateAPI()
        })
    }
    
    
    @IBAction func selectTransferCurrency(_ sender: UIButton) {
        let popupPickerView = AYPopupPickerView()
        //popupPickerView.pickerView.backgroundColor = UIColor.systemBackground
        popupPickerView.display(itemTitles: myCurrency, doneHandler: {
            let selectedIndex = popupPickerView.pickerView.selectedRow(inComponent: 0)
            sender.setTitle(self.myCurrency[selectedIndex], for: .normal)
            self.activeCurrency = self.myValue[selectedIndex]
            print(self.activeCurrency)
        })
    }
    
    
    @IBAction func calculateCurrency(_ sender: UIButton) {
        if(input.text != ""){
            resultLabel.text = String(Double(input.text!)! * activeCurrency)
        }
        
    }
    
    func exchangeRateAPI(){
        let url = URL(string: "https://v6.exchangerate-api.com/v6/API-KEY/latest/\(currencyInputTag.uppercased())")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error ) in
            if error != nil{
            } else{
                if let content = data{
                    do{
                        let jsonInfo = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        
                        if let rates = jsonInfo["conversion_rates"] as? NSDictionary{
                            for(key, value) in rates{
                                self.myCurrency.append((key as? String)!)
                                self.myCurrencyInput.append((key as? String)!)
                                self.myValue.append((value as? Double)!)
                                self.myValueInput.append((value as? Double)!)
                            }
                        }
                        
                    } catch {
                        print("Error!!")
                    }
                }
            }
        }
        task.resume()
    }
}

