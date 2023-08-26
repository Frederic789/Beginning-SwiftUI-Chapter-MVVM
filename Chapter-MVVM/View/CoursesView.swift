
import SwiftUI

struct CoursesView: View {
    @StateObject private var viewModel = ViewModel()

    @State private var showAddClassActionSheet = false
    @State private var newDiscName = ""
    @State private var newCourseName = ""
    @State private var newSectionName = ""
    @State private var selectedDiscipline: Discipline?

    var body: some View {
        VStack {
            Text("Courses")
                .font(.title)
            List {
                ForEach($viewModel.allClasses) { $disc in
                    Section(header: Text("\(disc.name) Courses:")) {
                        ForEach($disc.courses) { $course in
                            HStack {
                                Text(course.name)
                                Spacer()
                                if let selectedDiscipline = selectedDiscipline,
                                   let selectedCourse = $course.wrappedValue as? Course,
                                   let selectedSection = selectedCourse.sections.first(where: { $0.name == newSectionName }),
                                   !selectedSection.isEnrolled
                                {
                                    Button(action: {
                                        selectedSection.isEnrolled = true
                                        newSectionName = ""
                                    }) {
                                        Text("Enroll")
                                    }
                                } else {
                                    Text("Enrolled")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                }
            }
            Button("Add a course") {
                showAddClassActionSheet = true
            }
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(Capsule())
        }
        .padding()
        .fullScreenCover(isPresented: $showAddClassActionSheet) {
            VStack {
                Text("Add a new course").font(.title)
                Text("Discipline name:")
                TextField("Ex: ENG, BIT", text: $newDiscName)
                Text("Course name:")
                TextField("Ex: Shakespeare, Intro To Web Design", text: $newCourseName)
                Text("Section name:")
                TextField("Ex: M/W 11am-1pm", text: $newSectionName)
                HStack {
                    Button("Cancel") {
                        showAddClassActionSheet = false
                    }
                    Spacer()
                    Button("Save") {
                        if let selectedDiscipline = selectedDiscipline {
                            viewModel.addNewSection(discName: selectedDiscipline.name, courseName: newCourseName, sectionName: newSectionName)
                            newSectionName = ""
                            showAddClassActionSheet = false
                        }
                    }
                }.padding()
            }.padding()
        }
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
