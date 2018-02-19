//
//  EmojiDetailViewController.swift
//  emogiphy
//
//  Created by Vishnu on 16/05/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import Social
import MessageUI

class EmojiDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var gifImageView: UIImageView!
    var imageData: Data?
    var imageURL: String?
    var documentInteractionController: UIDocumentInteractionController = UIDocumentInteractionController()
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage.gif(data:imageData! as Data )
        gifImageView.image = image
        let barButton1 = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target:self, action: #selector(self.whatsAppAction))
        barButton1.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = barButton1
        self.navigationItem.title = "InstaGif"

    }
    @IBAction func twitterAction(_ sender: UIButton) {
            _ = twitterShareGiphy()
    }
    func twitterShareGiphy() -> Bool {
        // Check if sharing to Twitter is possible.
        var check = false
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            //twitterComposeVC?.setInitialText("sample test ")
            twitterComposeVC?.add(URL(string : imageURL!))
            // Display the compose view controller.
            check = true
            self.present(twitterComposeVC!, animated: true, completion: nil)
        } else {
               _ = SweetAlert().showAlert(title: "ALERT", subTitle: Message.twitterAlert, style: .Warning)
        }
        return check
    }
    @IBAction func facebookAction(_ sender: UIButton) {
         _ = facebookShareGiphy()
    }
    func facebookShareGiphy() -> Bool {
        var check = false
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookComposeVC?.add(URL(string : imageURL!))
            check = true
            self.present(facebookComposeVC!, animated: true, completion: nil)
        } else {
             _ = SweetAlert().showAlert(title: "ALERT", subTitle: Message.facebookAlert, style: .Warning)
        }
        return check
    }
    @IBAction func whatsAppAction(_ sender: UIButton) {
          _ = moreShareGiphy()
    }
    func moreShareGiphy() -> Bool {
        var check = false
//        let urlWhats = "whatsapp://app"
//        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) {
//            if let whatsappURL = URL(string: urlString) {
               // if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    if let image = imageData {
                        let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/giphyImage.gif")
                        do {
                            try image.write(to: tempFile, options: .atomic)
                            self.documentInteractionController = UIDocumentInteractionController(url: tempFile)
                            self.documentInteractionController.uti = "net.whatsapp.image"
                            self.documentInteractionController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
                            check = true
                        } catch {
                            print(error)
                        }
                    }
              //  }
//            }
//        }
       return check
    }
    @IBAction func messageAction(_ sender: UIButton) {
          _ = messageShareGiphy()
    }
    func messageShareGiphy() -> Bool {
        var check = false
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            //messageVC.recipients = ["9047595429"]
            //messageVC.body = "hello phone"
            if let image = imageData {
                messageVC.addAttachmentData(image, typeIdentifier: "com.compuserve.gif", filename: "animated.gif")
            }
            check = true
            self.present(messageVC, animated: true, completion: nil)
        } else {
               _ = SweetAlert().showAlert(title: "ALERT", subTitle: Message.iMessageAlert, style: .Warning)
        }
        return check
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
