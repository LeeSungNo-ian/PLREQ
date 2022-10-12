//
//  PLREQDataManager.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/11.
//

import Foundation
import UIKit
import CoreData

class PLREQDataManager {
    static let shared: PLREQDataManager = PLREQDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PLREQ")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let playListModelName: String = "PlayList"
    let MusicModelName: String = "Music"
    
    // 불러오기
    func fetch() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: playListModelName)
        
        let sort = NSSortDescriptor(key: "day", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        var result = [NSManagedObject]()
        
        do {
            result = try! context.fetch(fetchRequest)
        } catch {
            print("fetch fail")
        }
        
        return result
    }
    
    func save(title: String, location: String, day: Date, latitude: Float, longtitude: Float, firstImageURL: URL, secondImageURL: URL, thirdImageURL: URL, fourthImageURL: URL, musics: [Music]) -> Bool {
        let playListObject = NSEntityDescription.insertNewObject(forEntityName: playListModelName, into: context)
        playListObject.setValue(title, forKey: "title")
        playListObject.setValue(day, forKey: "day")
        playListObject.setValue(location, forKey: "location")
        playListObject.setValue(latitude, forKey: "latitude")
        playListObject.setValue(longtitude, forKey: "longtitude")
        playListObject.setValue(firstImageURL, forKey: "firstImageURL")
        playListObject.setValue(secondImageURL, forKey: "secondImageURL")
        playListObject.setValue(thirdImageURL, forKey: "thirdImageURL")
        playListObject.setValue(fourthImageURL, forKey: "fourthImageURL")
        for music in musics {
            let musicObject = NSEntityDescription.insertNewObject(forEntityName: MusicModelName, into: context) as! MusicDB
            musicObject.title = music.title
            musicObject.artist = music.artist
            musicObject.musicImageURL = music.musicImageURL
            
            (playListObject as! PlayListDB).addToMusic(musicObject)
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func delete(playListObject: NSManagedObject) -> Bool {
        context.delete(playListObject)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func musicsFetch(playList: PlayListDB) -> [MusicDB] {
        return playList.music?.array as! [MusicDB]
    }
}