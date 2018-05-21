//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Parse

let config = ParseClientConfiguration {
    $0.applicationId = "5++ejBLY/kzVaVibHAIIQZvbawrEywUCNqpD+FVpHgU="
    $0.clientKey = "oR3Jp5YMyxSBu6r6nh9xuYQD5AcsdubQmvATY1OEtXo="
    $0.server = "https://nathantannar.me/api/dev/"
}
Parse.initialize(with: config)
Parse.setLogLevel(.debug)

let query = PFUser.query()
query?.getFirstObjectInBackground(block: { object, error in
    print(object)
})

do {
    let object = try PFQuery(className: "_User").getFirstObject()
    print(object)
} catch _ {}

PlaygroundPage.current.needsIndefiniteExecution = true

