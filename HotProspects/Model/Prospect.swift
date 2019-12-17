//
//  Prospect.swift
//  HotProspects
//
//  Created by NICK POLYCHRONAKIS on 15/12/19.
//  Copyright © 2019 NICK POLYCHRONAKIS. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}




class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    init() {
        do {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = documentDirectory.appendingPathComponent("prospectData")
            
            //for debug porpuses, if I want to delete the file
//            try FileManager.default.removeItem(at: fileName);fatalError()
            
            if FileManager.default.fileExists(atPath: fileName.path) {
                let prospectData = try Data(contentsOf: fileName)
                let decoded = try JSONDecoder().decode([Prospect].self, from: prospectData)
                self.people = decoded
                return
            }
        } catch {
            #warning("Change this")
            fatalError()
        }
        // or else
        self.people = []
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    private func save() {
        do {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = documentDirectory.appendingPathComponent("prospectData")
            let encoded = try JSONEncoder().encode(people)
            try encoded.write(to: fileName, options: [.atomicWrite,.completeFileProtection])
        } catch {
            #warning("Change this")
            fatalError()
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
