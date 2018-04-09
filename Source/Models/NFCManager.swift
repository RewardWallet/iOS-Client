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
    
    typealias NFCManagerCallback = (URL)->Void
    
    static var shared = NFCManager()
    
    // MARK: - Properties
    
    private var session: NFCNDEFReaderSession?
    
    private var callback: NFCManagerCallback?
    
    // Private Init, use shared singleton
    private override init() {
        super.init()
    }
    
    // MARK: - Public API
    
    func beginReading(callback: NFCManagerCallback?) {
        self.callback = callback
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Tap your iPhone on the RewardBeamer"
        session?.begin()
    }
    
    func endReading() {
        session?.invalidate()
        session = nil
    }
    
    // MARK: - Private API
    
    fileprivate func executeCallback(with url: URL) {
        DispatchQueue.main.async {
            self.callback?(url)
            self.endReading()
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
//
//        for message in messages {
//            for record in message.records {
//                print("Type name format: \(record.typeNameFormat)")
//                print("Payload: \(record.payload)")
//                print("Type: \(record.type)")
//                print("Identifier: \(record.identifier)")
//                print(URL(dataRepresentation: record.payload, relativeTo: nil))
//            }
//        }
//
        guard let urlString = URL(dataRepresentation: messages[0].records[0].payload, relativeTo: nil)?.absoluteString.replacingOccurrences(of: "%00", with: "") else {
            print("Failed to convert to URL string")
            return
        }
        let url = URL(string: urlString)!
        executeCallback(with: url)
    }
}
