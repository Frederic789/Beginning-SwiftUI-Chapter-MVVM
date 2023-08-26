//
//  CoursesModel.swift
//  Chapter-MVVM
//
//  Created by Mike Panitz on 5/16/23.
//

import Foundation

var theCollege = College()


class College {
    @Published var allClasses: [Discipline] = []
    
    init() {
        load()
    }
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("NameOfFileToSaveDataIn")
    func save() {
        
        // documentsDirectory is a non-standard property that we added, below
        do {
            let data = try JSONEncoder().encode(allClasses)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func load() {
        do {
            let data = try Data(contentsOf: savePath)
            allClasses = try JSONDecoder().decode([Discipline].self, from: data)
        } catch {
            //allClasses = []
            loadDefaultData()
        }
    }
    
    func loadDefaultData() {
        allClasses =  [
            Discipline(name: "MoBAS",
                       courses:
                        [Course(name: "BIT 101"),
                         Course(name: "BIT 102")]),
            Discipline(name: "English",
                       courses:
                        [Course(name: "ENG 101"),
                         Course(name: "ENG 102")])
        ]
    }
    
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct Discipline : Identifiable, Codable {
    let id = UUID()
    let name:String
    var courses: [Course]
}

struct Course : Identifiable, Codable {
    let id = UUID()
    let name:String
    var isEnrolled = false
    var sections: [Section] = []
 
}

struct Section: Identifiable, Codable {
    let id = UUID()
    var name: String
    var isEnrolled = false
}



