//
//  ViewController.swift
//  LiveQueryTest
//
//  Created by Ayrton Alves on 03/01/17.
//  Copyright © 2017 back4app. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery


let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://livequeryexample.back4app.io")

class ViewController: UIViewController {
    
    private var subscription: Subscription<PFObject>!
    
    func alert(message: NSString, title: NSString) -> Void {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Loaded view")

        let msgQuery = PFQuery(className: "Message").whereKeyExists("destination")
        subscription = liveQueryClient.subscribe(msgQuery).handle(Event.created) { _, message in
            if Thread.current != Thread.main {
                return DispatchQueue.main.async {
                    self.alert(message: "You have been poked.", title: "Poked")
                }
            } else {
                self.alert(message: "You have been poked.", title: "Poked")
            }
        }
    }

    @IBAction func sendPoke(_ sender: Any) {
        let message: PFObject = PFObject(className: "Message")
        message["destination"] = "pokelist"
        message["content"] = "poke"
        
        message.saveInBackground { (_, er) in
            if !(er != nil) {
                print("Message uploaded to back4app")
            } else {
                print(er as Any)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

