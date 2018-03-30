//
//  NFCManager.swift
//  RewardWallet
//
//  Created by Nathan Tannar on 3/29/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import CoreNFC

final class NFCManager: NSObject {
    
    typealias NFCManagerCallback = ([NFCNDEFMessage])->Void
    
    static var shared = NFCManager()
    
    // MARK: - Properties
    
    private lazy var session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    
    private var callback: NFCManagerCallback?
    
    // Private Init, use shared singleton
    private override init() {
        super.init()
        session.alertMessage = "Tap your iPhone on the RewardBeamer"
    }
    
    // MARK: - Public API
    
    func beginReading(callback: NFCManagerCallback?) {
        self.callback = callback
        session.begin()
    }
    
    // MARK: - Private API
    
    fileprivate func executeCallback(with messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            self.callback?(messages)
        }
    }
    
}

// MARK: - NFCNDEFReaderSessionDelegate
extension NFCManager: NFCNDEFReaderSessionDelegate {
    
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
        
        executeCallback(with: messages)
    }
}
