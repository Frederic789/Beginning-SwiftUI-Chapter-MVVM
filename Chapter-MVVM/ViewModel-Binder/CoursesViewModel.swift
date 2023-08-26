//
//  CoursesViewModel.swift
//  Chapter-MVVM
//
//  Created by Mike Panitz on 5/16/23.
//

import Foundation


extension CoursesView {
    @MainActor class ViewModel: ObservableObject {
        @Published var allClasses = theCollege.allClasses
        @Published var enrollmentOpen = false // are student allowed to enroll right now?
        @Published var courseChangesAllowed = false // can college employees make changes to the courses right now?
        
        func addNewCourse( discName: String, courseName: String) {
            print("Create new course: \(discName) \(courseName)")
            
            for idx in theCollege.allClasses.indices {
                print("\tChecking \(theCollege.allClasses[idx].name)")
                
                if theCollege.allClasses[idx].name == discName {
                    print("\tFound discipline named \(discName)")
                    for course in theCollege.allClasses[idx].courses {
                        if course.name == courseName {
                            print("\tFound duplicate - ignoring")
                            return
                        }
                    }
                    print("Adding \(courseName) to \(discName)")
                    // add new course to existing discipline:
                    let course = Course(name: courseName)
                    theCollege.allClasses[idx].courses.append(course)
                    return
                }
            }
            print("Couldn't find discipline named \(discName), so create an entirely new one")
            let course = Discipline(name: discName, courses: [Course(name: courseName)])
            allClasses.append(course)
            return
        }
    }
}
