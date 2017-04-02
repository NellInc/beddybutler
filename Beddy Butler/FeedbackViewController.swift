//
//  FeedbackViewController.swift
//  Beddy Butler
//
//  Created by David Garces on 09/02/2017.
//  Copyright © 2017 David Garces. All rights reserved.
//

import Cocoa

class FeedbackViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet weak var includeActivityButton: NSButton!
    @IBOutlet weak var sendEmailButton: NSButton!
    @IBOutlet var feedbackTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        sendEmailButton.isEnabled = false
        
        //feedbackTextView.usesFontPanel = true
        //let fontManager = NSFontManager.shared()
        //fontManager.target = self
        
    }
    
//    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
//        
//        if commandSelector == #selector(insertNewline(_:)) {
//            textView.insertNewlineIgnoringFieldEditor(self)
//            return true
//        } else if commandSelector == #selector(insertTab(_:)) {
//            textView.insertTabIgnoringFieldEditor(self)
//            return true
//        } //else if commandSelector == #selector(changeColor(_:)) {
//            //textView.setTextColor(NSFontPanel.colo, range: <#T##NSRange#>)
//        //}
//        
//        return false
//        
//    }
    func textDidChange(_ notification: Notification) {
        if !sendEmailButton.isEnabled && feedbackTextView.attributedString().string.characters.count > 20 {
            sendEmailButton.isEnabled = true
        }
        
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        let includeActivity = includeActivityButton.state == NSOnState
        var logHeading = "\nLog Activity:\n"
        var separated: String?
        
        let mailService = NSSharingService(named: NSSharingServiceNameComposeEmail)
        mailService?.recipients = ["BeddyButler@nellwatson.com"]
        mailService?.subject = "Beddy Butler feedback"
        
        if let log = AppDelegate.userDefaultsLog {
            separated = log.map({ "\($0.date) - \($0.message)" }).joined(separator: " \n")
            let osVersion = "OS \(ProcessInfo.processInfo.operatingSystemVersionString) \n"
            separated = "\(osVersion) \(separated ?? "")"
            if log.count == 0 { logHeading = "\nLog record empty\n" }
        }else {
            logHeading = "\nNo Log record present in App\n"
        }
        
        //append line break to attributed string between log and message
        
        let linebreak = NSAttributedString(string: logHeading)
        
        let shareItems = includeActivity ? [feedbackTextView.attributedString(), linebreak, separated ?? ""] : [feedbackTextView.attributedString()]
        
        mailService?.perform(withItems: shareItems)
        
        self.dismiss(self)
        
    }
    


    
}
