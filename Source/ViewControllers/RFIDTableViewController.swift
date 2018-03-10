//
//  RFIDTableViewController.swift
//  RewardWallet
//
//  Created by MOLLY BIN on 2018-03-09.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import CoreNFC

class RFIDTableViewController: UITableViewController {
    
    // Reference the RFID session
    private var rfidSession: NFCISO15693ReaderSession!
    
    // Reference the found NFC messages
    private var rfidTags: [[NFCISO15693Tag]] = []
    
    
    // Dismisses the current RFID view-controller
    @IBAction func dismissViewController(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RFID Test"
        
        //self.tableView.register(NFCTableViewCell.self, forCellReuseIdentifier: "NFCTableCell")
        
        // Create the RFID Reader Session when the app starts
        self.rfidSession = NFCISO15693ReaderSession(delegate: self, queue: nil)
        self.rfidSession.alertMessage = "You can scan RFID-tags by holding them behind the top of your iPhone."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Begin scanning
        self.rfidSession.begin()
    }
}

// MARK: UITableViewDelegate / UITableViewDataSource
extension RFIDTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.rfidTags.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rfidTags[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let numberOfMessages = self.rfidTags[section].count
        let headerTitle = numberOfMessages == 1 ? "One Tag" : "\(numberOfMessages) Tags"
        
        return headerTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NFCTableCell", for: indexPath) as! NFCTableViewCell
        let nfcTag = self.rfidTags[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = "\(nfcTag.identifier) (\(nfcTag.icSerialNumber))"
        cell.detailTextLabel?.text = "Available: \(nfcTag.isAvailable)"
        
        return cell
    }
}

// MARK: NFCNDEFReaderSessionDelegate
extension RFIDTableViewController : NFCReaderSessionDelegate {
    
    func readerSession(_ session: NFCReaderSession, didInvalidateWithError error: Error) {
        print("Error reading RFID-Tag: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCReaderSession, didDetect tags: [NFCTag]) {
        print("New RFID-Tags detected:")
        
        for tag in tags {
            let rfidTag = tag as! NFCISO15693Tag
            
            print("Is available: \(rfidTag.isAvailable)")
            print("Type: \(rfidTag.type)")
            print("IC Manufacturer Code: \(rfidTag.icManufacturerCode)")
            print("Serial Number: \(rfidTag.icSerialNumber)")
            print("Identifier: \(rfidTag.identifier)")
            
            // Uncomment to send a custom command. Not sure, yet what to send here.
            //            rfidTag.sendCustomCommand(commandConfiguration: NFCISO15693CustomCommandConfiguration(manufacturerCode: rfidTag.icManufacturerCode,
            //                                                                                                  customCommandCode: 0,
            //                                                                                                  requestParameters: nil),
            //                                      completionHandler: { (data, error) in
            //                                        guard error != nil else {
            //                                            return print("Error sending custom command: \(String(describing: error))")
            //                                        }
            //
            //                                        print("Data: \(data)")
            //            })
        }
        
        // Add the new tags to our found tags
        self.rfidTags.append(tags as! [NFCISO15693Tag])
        
        // Reload our table-view on the main-thread to display the new data-set
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCReaderSession) {
        print("RFID-Tag (\(session)) session did become active")
    }
}
