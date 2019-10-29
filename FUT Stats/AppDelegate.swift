//
//  AppDelegate.swift
//  FUT Stats
//
//  Created by POLARIS on 01/31/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleSignIn
import UserNotifications
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate,
    MessagingDelegate, GADInterstitialDelegate, XMLParserDelegate {
    
    var window: UIWindow?
    var timer: DispatchSourceTimer?
    var interstitialAds: GADInterstitial?
    
    var mCellCount = 0
    var keyArray = [String]()
    var mMiddleString = ""
    var mStationFlag = ""
    var mStringId = ""
    var nCurrentElement = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        //Messaging.messaging().delegate = self
        //Messaging.messaging().shouldEstablishDirectChannel = true
        
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        UIApplication.shared.isStatusBarHidden = true
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        self.initializeFCM(application)
        let token = InstanceID.instanceID().token()
        debugPrint("GCM TOKEN = \(String(describing: token))")
        return true
    }

    func sendAdsRequest() {
        interstitialAds = createInterstitialAds()
    }
    
    func createInterstitialAds() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8237427337147440/9854060440")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        let view = UIApplication.shared.keyWindow!
        interstitialAds?.present(fromRootViewController: view.currentViewController()!)
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print("Failed to login to Google :", error)
            return
        }
        print("Success to login with Google")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            // Print log if user signed in
            print("Success to login Firebase with google account")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let viewController = storyboard.instantiateViewController(withIdentifier: "MainVC")
            let rootViewController = self.window!.rootViewController
            rootViewController?.present(viewController, animated: true);
        }
    }
    
    func startTimer() {
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(60))
        timer!.setEventHandler { [weak self] in
            print("The timer started!")
            self?.dataUpdateFromXml()
        }
        timer!.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        print("The timer stopped!")
        timer = nil
    }
    
    deinit {
        self.stopTimer()
    }
    
    func dataUpdateFromXml() {
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        var stringId = ""
        var stationFlag = ""
        var recCount = 0
        
        db.collection("\(userId)").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)");
            } else {
                DispatchQueue.main.async() {
                    for document in querySnapshot!.documents {
                        if document.data().count < 10 {
                            let xmlFlag = document.data()["XmlSuccess"] as? String
                            if xmlFlag == "0" {
                                stringId = document.documentID
                                stationFlag = document.data()["Home"] as! String
                                recCount += 1
                                self.updateDataWithXml(stringId: stringId, stationFlag: stationFlag)
                            }
                        }
                    }
                    
                    /*if recCount > 0 {
                        self.updateDataWithXml(stringId: stringId, stationFlag: stationFlag)
                    } else {
                        print("There is none to need parsing xml.")
                        return
                    }*/
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func updateDataWithXml(stringId: String, stationFlag: String) {
        print(stringId)
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let userName = Auth.auth().currentUser?.displayName
        let userId = Auth.auth().currentUser?.uid
        let storeName = userName! + "_" + userId!
        let fileName = stringId + "_0001.xml"

        self.mStationFlag = stationFlag
        self.mStringId = stringId

        let xmlRef = storageRef.child ("\(storeName)/\(fileName)")
        xmlRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print ( error )
            } else {
                //Convert NSData to NSString.
                self.mCellCount = 0
                self.keyArray = [String]()
                self.mMiddleString = ""

                // parse start !
                let parser = XMLParser(data: data!)
                parser.delegate = self as? XMLParserDelegate
                var xml = parser.parse()
                
            }
        }
    }
    
    func updateDB() {
        //update data to cloud store
        let userId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        var successFlag = false
        if self.keyArray.count >= 27 {
            self.keyArray.remove(at: 1)
            if self.keyArray.count == 26 {
                var index = 2
                repeat {
                    let num1 = Int( self.keyArray[index] )
                    if num1 == nil {
                        break
                    }
                    let num2 = Int( self.keyArray[index+2] )
                    if num2 == nil {
                        break
                    }
                    index += 3
                } while ( index < 26  )
                if index >= 26 {
                    successFlag = true
                }
            }
        }
        if successFlag == false {
            print("Wow, xml error")
            // Set xml success value to false(1)
            self.updateXmlFieldToFalse(userId: userId!, stringId: self.mStringId)
            return
        }

        if self.mStationFlag == "1" {
        let updateData: [String: String] = [
        "My Corners" : "\(keyArray[17])",
        "My Fouls" : "\(keyArray[14])",
        "My Pass Accuracy %" : "\(keyArray[23])",
        "My Possession %" : "\(keyArray[8])",
        "My Shot Accuracy %" : "\(keyArray[20])",
        "My Shots" : "\(keyArray[2])",
        "My Shots on Targets" : "\(keyArray[5])",
        "My Tackles" : "\(keyArray[11])",
        "Op Corners" : "\(keyArray[19])",
        "Op Fouls" : "\(keyArray[16])",
        "Op Pass Accuracy %" : "\(keyArray[25])",
        "Op Possession %" : "\(keyArray[10])",
        "Op Shot Accuracy %" : "\(keyArray[22])",
        "Op Shots" : "\(keyArray[4])",
        "Op Shots on Targets" : "\(keyArray[7])",
        "Op Tackles" : "\(keyArray[13])"
        ]
            db.collection(userId!).document(self.mStringId).updateData(updateData)
        } else {
            let updateData: [String: String] = [
            "My Corners" : "\(keyArray[19])",
            "My Fouls" : "\(keyArray[16])",
            "My Pass Accuracy %" : "\(keyArray[25])",
            "My Possession %" : "\(keyArray[10])",
            "My Shot Accuracy %" : "\(keyArray[22])",
            "My Shots" : "\(keyArray[4])",
            "My Shots on Targets" : "\(keyArray[7])",
            "My Tackles" : "\(keyArray[13])",
            "Op Corners" : "\(keyArray[17])",
            "Op Fouls" : "\(keyArray[14])",
            "Op Pass Accuracy %" : "\(keyArray[23])",
            "Op Possession %" : "\(keyArray[8])",
            "Op Shot Accuracy %" : "\(keyArray[20])",
            "Op Shots" : "\(keyArray[2])",
            "Op Shots on Targets" : "\(keyArray[5])",
            "Op Tackles" : "\(keyArray[11])"
            ]
            db.collection(userId!).document(self.mStringId).updateData(updateData)
        }
    }
    
    func updateXmlFieldToFalse(userId: String, stringId: String) {
        let db = Firestore.firestore()
        db.collection("\(userId)").document("\(stringId)").updateData(["XmlSuccess": "1"])
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        debugPrint("--->messaging:\(messaging)")
        debugPrint("--->didRefreshRegistrationToken:\(fcmToken)")
    }
    
    @available(iOS 10.0, *)
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        debugPrint("--->messaging:\(messaging)")
        debugPrint("--->didReceive Remote Message:\(remoteMessage.appData)")
        guard let data =
            try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else { return }
        print("Received direct channel message:\n\(prettyPrinted)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //FIRMessaging.messaging().disconnect()
        
        debugPrint("###> 1.2 AppDelegate DidEnterBackground")
        //        self.doServiceTry()
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //        connectToFcm()
        application.applicationIconBadgeNumber = 0
        debugPrint("###> 1.3 AppDelegate DidBecomeActive")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        debugPrint("remoteMessage:\(remoteMessage.appData)")
    }
    
    func initializeFCM(_ application: UIApplication) {
        print("initializeFCM")
        UNUserNotificationCenter.current().delegate = self
        //-------------------------------------------------------------------------//
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        
        //FirebaseApp.configure()
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
                                               name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
    }
    
    @objc func tokenRefreshNotificaiton(_ notification: Foundation.Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            debugPrint("InstanceID token: \(refreshedToken)")
        }
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else { return }
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().shouldEstablishDirectChannel = false
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        debugPrint("didRegister notificationSettings")
        if (notificationSettings.types == .alert || notificationSettings.types == .badge || notificationSettings.types == .sound) {
            application.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification ON APP
        debugPrint("*** willPresent notification")
        debugPrint("*** notification: \(notification)")
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification ON BACKGROUND
        debugPrint("*** didReceive response Notification ")
        debugPrint("*** response: \(response)")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        debugPrint("didRegisterForRemoteNotificationsWithDeviceToken: NSDATA")
        
        let token = String(format: "%@", deviceToken as CVarArg)
        debugPrint("*** deviceToken: \(token)")
        //        #if RELEASE_VERSION
        //            InstanceID.instanceID().setAPNSToken(deviceToken as Data, type:FIRInstanceIDAPNSTokenType.prod)
        //        #else
        //            InstanceID.instanceID().setAPNSToken(deviceToken as Data, type:InstanceIDAPNSTokenType.sandbox)
        //        #endif
        Messaging.messaging().apnsToken = deviceToken as Data
        debugPrint("Firebase Token:",InstanceID.instanceID().token() as Any)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debugPrint("didRegisterForRemoteNotificationsWithDeviceToken: DATA")
        let token = String(format: "%@", deviceToken as CVarArg)
        debugPrint("*** deviceToken: \(token)")
        //        #if RELEASE_VERSION
        //            FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type:FIRInstanceIDAPNSTokenType.prod)
        //        #else
        //            InstanceID.instanceID().setAPNSToken(deviceToken as Data, type:InstanceIDAPNSTokenType.sandbox)
        //        #endif
        Messaging.messaging().apnsToken = deviceToken
        debugPrint("Firebase Token:",InstanceID.instanceID().token() as Any)
    }
    //-------------------------------------------------------------------------//
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo["gcm.message_id"] {
            debugPrint("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("###> 1.3 AppDelegate applicationWillTerminate")
        //DatabaseHelper.cleanup()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.nCurrentElement = ""
        if elementName == "cell" {
            self.mCellCount += 1
        }
        else if elementName == "wd" {
            self.nCurrentElement = "wd"
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "wd" {
            self.mMiddleString += " "
        }
        else if elementName == "ln" {
            let realString = self.mMiddleString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.keyArray.append(realString)
            self.mMiddleString = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.nCurrentElement == "wd" {
            if string != "\n" {
                self.mMiddleString += string
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
        self.mMiddleString = ""
        self.keyArray.removeAll()
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("parser end!")
        self.updateDB()
    }
}

