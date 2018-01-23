//
//  NFCTableViewController.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 1/22/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import CoreNFC

class NFCTableViewController: UITableViewController {
    
    // Reference the NFC session
    private var nfcSession: NFCNDEFReaderSession!
    
    // Reference the found NFC messages
    private var nfcMessages: [[NFCNDEFMessage]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the NFC Reader Session when the app starts
        self.nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        
        // A custom description that helps users understand how they can use NFC reader mode in your app.
        self.nfcSession.alertMessage = "You can hold you NFC-tag to the back-top of your iPhone"
        
        // Begin scanning
        self.nfcSession.begin()
    }
    
}

extension NFCTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.nfcMessages.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nfcMessages[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let numberOfMessages = self.nfcMessages[section].count
        let headerTitle = numberOfMessages == 1 ? "One Message" : "\(numberOfMessages) Messages"
        
        return headerTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NFCTableCell", for: indexPath) as! NFCTableViewCell
        let nfcTag = self.nfcMessages[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = "\(nfcTag.records.count) Records"
        
        return cell
    }
}


extension NFCTableViewController : NFCNDEFReaderSessionDelegate {
    
    // Called when the reader-session expired, you invalidated the dialog or accessed an invalidated session
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error reading NFC: \(error.localizedDescription)")
    }
    
    // Called when a new set of NDEF messages is found
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("New NFC Tag detected:")
        
        for message in messages {
            for record in message.records {
                print("Type name format: \(record.typeNameFormat)")
                print("Payload: \(record.payload)")
                print("Type: \(record.type)")
                print("Identifier: \(record.identifier)")
            }
        }
        
        // Add the new messages to our found messages
        self.nfcMessages.append(messages)
        
        // Reload our table-view on the main-thread to display the new data-set
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

