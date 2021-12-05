//
//  AppDelegate.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var locationManager: CLLocationManager?
    var notificationCenter: UNUserNotificationCenter?
    weak var routeDelegate: RouteDelegate?
    
    //O ideal é fazer um singleton
    var clickedLocation: CLLocationCoordinate2D?
    
    var hasAlreadyLaunched: Bool!
    
    weak var annotationDelegate: AnnotationDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        
        if !hasAlreadyLaunched {
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
            self.preLoadCoreData()
        }
            
        // Override point for customization after application launch.
        self.notificationCenter = UNUserNotificationCenter.current()
        notificationCenter!.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        notificationCenter!.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Permission not granted")
            }
        }
        
        return true
    }

    
    func populateCoreDataAchievements() {
        guard let path = Bundle.main.path(forResource: "Achievements", ofType: "json") else {return}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let context = persistentContainer.newBackgroundContext()
            let decoder = JSONDecoder()
            decoder.userInfo[.context!] = context
            let result = try decoder.decode([Achievement].self, from: data)

            for object in result {
                do {
                    let achievementService = AchievementService()
                    let _ = try achievementService.create(achievementID: object.achievementID, objective: object.objective!, name: object.name!, progress: object.progress, xpPoints: object.xpPoints)
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func populateCoreDataPlaces() {
        guard let path = Bundle.main.path(forResource: "Places", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let context = persistentContainer.newBackgroundContext()
            let decoder = JSONDecoder()
            decoder.userInfo[.context!] = context
            let result = try decoder.decode([Place].self, from: data)
            for object in result {
                let _ = try! PlaceService().create(name: object.name!, latitude: object.latitude, longitude: object.longitude, placeID: object.placeID, nImages: object.nImages, relatedAchievements: object.relatedAchievements!)
            }
            
            _ = try! UserService().create(name: "goCampus")
            
        } catch {
            print("\(error)")
        }
    }
    
    // MARK: First CoreData Load
    func preLoadCoreData() {
        populateCoreDataPlaces()
        populateCoreDataAchievements()
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "campusGo")
        container.persistentStoreDescriptions.append(storeDescription)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var storeDescription: NSPersistentStoreDescription = {
            let storeDescription = NSPersistentStoreDescription()
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = true
            return storeDescription
    }()
    
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Geofencing and push Notification

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
            locationManager?.stopMonitoring(for: region)
        }
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        let placeService = PlaceService()
        let validator = Validator()
        let alertUtil = AlertUtil()
        
        let uid = UUID(uuidString: region.identifier)
        let onRoute = placeService.isOnRoute(uid: uid!)
        let wasDiscovered = placeService.wasDiscovered(uid: uid!)
        let content = UNMutableNotificationContent()
        if(wasDiscovered) {
            content.title = "Parabéns!"
            content.body = "Você chegou ao seu destino"
        } else {
            content.title = "Parabéns!"
            content.body = "Lugar desbloqueado"
        }
        content.sound = UNNotificationSound.default

        let timeInSeconds: TimeInterval = (1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds, repeats: false)

        let identifier = region.identifier

        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        // if region was on route switch place state to "known" and show notification
        if (onRoute) {
            try! placeService.updateState(uid: uid!, newState: PlaceState.known)
            annotationDelegate?.updateAnnotations()
            locationManager?.stopMonitoring(for: region!)
            notificationCenter!.add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("Error adding notification with identifier: \(identifier)")
                }
            })
            routeDelegate?.didTapCancel()
            if(!wasDiscovered) {
                var place: Place?
                do {
                    place = try placeService.read(uid: uid!)
                } catch {
                    print(error)
                }
                if let currentViewController = getCurrentViewController(){
                    if let alertViewController = currentViewController.children[0] as? AlertViewDelegate {
                        alertUtil.showAlert(viewController: alertViewController,place: place,achievement: nil)
                    } else{
                        print("Erro ao encontrar a view")
                    }
                }
            }
        }
        
        let achievements = validator.didValidate()
        if (achievements.isEmpty) { return }
        for achievement in achievements {
            if let currentViewController = getCurrentViewController() {
                if let alertViewController = currentViewController.children[0] as? AlertViewDelegate {
                    alertUtil.showAlert(viewController: alertViewController,place: nil, achievement: achievement)
                } else {
                    print("Erro ao encontrar a view")
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is open and in foregroud
        completionHandler([.list, .banner])
    }
}


