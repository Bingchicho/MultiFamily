//
//  AddViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import UIKit

class AddViewController: UIViewController {

    var provisionBLEInfo: ProvisionBLEInfo?
    var remotePinCode: String?
    
    @IBOutlet weak var idTitleLabel: AppLabel!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var nameTitleLabel: AppLabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var areaTitieLabel: AppLabel!
    @IBOutlet weak var areaButton: TintedButton!
    
    @IBOutlet weak var autoTitleLabel: AppLabel!
    @IBOutlet weak var autoSwitch: UISwitch!
    
    @IBOutlet weak var autoTimeTitieLabel: AppLabel!
    @IBOutlet weak var autoTimeButton: TintedButton!
    
    @IBOutlet weak var beepTitleLabel: AppLabel!
    @IBOutlet weak var beepSwitch: UISwitch!
    
    @IBOutlet weak var powerTitieLabel: AppLabel!
    @IBOutlet weak var powerButton: TintedButton!
    
    @IBOutlet weak var advTitieLabel: AppLabel!
    @IBOutlet weak var advButton: TintedButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}
