//
//  ViewController.swift
//  p6
//
//  Created by Jonathan on 4/26/19.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import Alamofire
import GoogleAPIClientForREST
import GoogleToolboxForMac
import GoogleSignIn
import UIKit


class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet show_shifts_button: UIButton!
    @IBOutlet submit_shifts_button: UIButton!
    @IBOutlet submit_button: UIButton!
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app. kGTLRAuthScopeSheetsSpreadsheetsReadonly
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets]
    
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()
    let output = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.clientID = "115174881544829311706"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        
        // Add a UITextView to display output.
        output.frame = view.bounds
        output.isEditable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        output.isHidden = true
        view.addSubview(output);
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            appendShifts()
        }
    }
    
    // Display (in the UITextView) the names and majors of students in a sample
    // spreadsheet:
    // https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
    func listShifts() {
        
        let spreadsheetId = "1F44M21u6rCOAeeFxhd0q3_XTTET3fCGgVzNF3RyxdXo"
        let range = "A1:Q"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        
        service.executeQuery(query) { (ticket, result, error) in
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            guard let result = result as? GTLRSheets_ValueRange else {
                return
            }
            
            let rows = result.values!
            
            if rows.isEmpty {
                self.output.text = "No shifts!"
                return
            }
            
            
        }
    }
    
    func appendShifts() {
        
        let spreadsheetId = "1F44M21u6rCOAeeFxhd0q3_XTTET3fCGgVzNF3RyxdXo"
        let range = "A1:Q"
        let rangeToAppend = GTLRSheets_ValueRange.init();
        if (submit_button){
            let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: rangeToAppend, spreadsheetId: spreadsheetId, range: range)
            query.valueInputOption = "USER_ENTERED"
            
            service.executeQuery(query) { (ticket, result, error) in
                
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.output.text = "Success!"
                }
            }
        }
    }
    
  
    func displayResultWithTicket(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRSheets_ValueRange,
                                 error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        
        let rows = result.values!
        
        if rows.isEmpty {
            output.text = "No shifts"
            return
        }
        
    }
    
    
    
    func mainMenu(){
        if(show_shifts_button){
            listShifts()
        }
        if(submit_shifts_button){
            appendShifts()
        }
        
    }
   
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
