//
//  ViewController.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 18/04/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    var refArtists: DatabaseReference!
    var artistList = [ArtistModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refArtists = Database.database().reference().child("Artist")
//        addArtist()
    }

    func addArtist(){
            //generating a new key inside artists node
            //and also getting the generated key
            let key = refArtists.childByAutoId().key
            
            //creating artist with the given values
            let artist = ["id":key,
                            "artistName": "Artist/one",
                            "artistGenre": "Proofreading"
                            ]
        
            //adding the artist inside the generated unique key
        refArtists.child(key!).setValue(artist)
        readArtist()
            //displaying message
            
        }
    func readArtist(){
        refArtists.observe(DataEventType.value, with: { (snapshot) in
                   
                   //if the reference have some values
                   if snapshot.childrenCount > 0 {
                       
                       //clearing the list
                       self.artistList.removeAll()
                       
                       //iterating through all the values
                       for artists in snapshot.children.allObjects as! [DataSnapshot] {
                           //getting values
                           let artistObject = artists.value as? [String: AnyObject]
                           let artistName  = artistObject?["artistName"]
                           let artistId  = artistObject?["id"]
                           let artistGenre = artistObject?["artistGenre"]
                           
                           //creating artist object with model and fetched values
                           let artist = ArtistModel(id: artistId as! String?, name: artistName as! String?, genre: artistGenre as! String?)
                           
                           //appending it to list
                           self.artistList.append(artist)
                       }
                       print(self.artistList)
                       //reload the ui or tableview
                       
                   }
               })
    }
}

class ArtistModel {
    
    var id: String?
    var name: String?
    var genre: String?
    
    init(id: String?, name: String?, genre: String?){
        self.id = id
        self.name = name
        self.genre = genre
    }
}
