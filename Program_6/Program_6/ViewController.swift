//
//  ViewController.swift
//  Program_6
//
//  Created by Kevin Ren on 4/15/19.
//  Copyright © 2019 Binghamton University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    -(IBAction)signUpUserPressed:(id)sender
    {
    //1
    PFUser *user = [PFUser user];
    //2
    user.username = self.userRegisterTextField.text;
    user.password = self.passwordRegisterTextField.text;
    //3
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
    //The registration was successful, go to the wall
    [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
    
    } else {
    //Something bad has occurred
    NSString *errorString = [[error userInfo] objectForKey:@"error"];
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
    }
    }];
    }
    
    -(IBAction)signUpUserPressed:(id)sender
    {
    //TODO
    //If signup sucessful:
    //[self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
    }
    
    -(IBAction)logInPressed:(id)sender
    {
    //If user logged succesful:
    //[self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
    
    }
}

