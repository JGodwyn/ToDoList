//
//  ToDoDetail.swift
//  ToDoList
//
//  Created by Gdwn16 on 04/12/2025.
//

import SwiftUI
import SwiftData
import PhotosUI
import SwiftUIImageViewer

struct ToDoDetail: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    // @Bindable is interesting cos in this context, it works
    // the same way as @Binding. the thing is @Bindable is only
    // used on SwiftData models and Observable objects
    // @Bindable affects the object itself whereas
    // @Binding affects the parent's object
    @Bindable var todoObj : TodoItem
    @Query(sort: \Categories.created, order: .reverse) private
        var categoriesQuery: [Categories]
    @State private var todoTemp : ToDoTemp = .example
    @State private var selectedCategoryIDs: Set<PersistentIdentifier>
    @State private var selectedPhoto : PhotosPickerItem?
    @State private var photoIsSelected : Bool = false
    @State private var isImagePresented : Bool = false
    
    // initialize the categories
    init(todoObj: TodoItem) {
        self.todoObj = todoObj
        _selectedCategoryIDs = State(initialValue: Set(todoObj.categories.map { $0.persistentModelID }))
        
        // a few things going on here
        // 1. why do we need an init() instead of something like this? @State private var selectedCategoryIDs: Set<PersistentIdentifier> = Set(todoObj(…
        // that's an error in Swift because item don't exist when you're creating the object
        // 2. why the '_'? this is to tell Swift that selectedCategoryIDs should point to the one outside (they should be the same object)
        // 3. What does State(initialValue:…) mean? well that's like saying @State private var… . just like in #1, item don't exist outside yet, you need to wrap it in an init to get the value. this is because of the dependency on item.
        
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                TextField("Name", text: $todoTemp.title)
                    .padding()
                    .padding(.horizontal, 4)
                    .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24))
                DatePicker("Date", selection: $todoTemp.timeStamp)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                Toggle("Important", isOn: $todoTemp.isCritical)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                
                HStack {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack {
                            Image(
                                systemName: todoTemp.image == nil
                                    ? "plus" : "pencil"
                            )
                            Text(
                                todoTemp.image == nil
                                    ? "Tap to add photo" : "Change photo"
                            )
                            .fontWeight(.medium)
                        }
                        .foregroundStyle(
                            todoTemp.image == nil ? .gray : BrandColors.BrandMain
                        )

                    }
                    
                    Spacer()
                    
                    if let imageData = todoTemp.image,
                        let uiImage = UIImage(data: imageData)
                    {
                        HStack(spacing: 12) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 56, height: 40)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 8,
                                        style: .continuous
                                    )
                                )
                                .onTapGesture {
                                    withAnimation(.smooth(duration: 0.3)) {
                                        isImagePresented = true
                                    }
                                }
                                .fullScreenCover(isPresented: $isImagePresented) {
                                    SwiftUIImageViewer(image: Image(uiImage: uiImage))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                withAnimation(.smooth(duration: 0.3)) {
                                                    isImagePresented = false
                                                }
                                            } label: {
                                                Image(systemName: "xmark")
                                                    .font(.headline)
                                            }
                                            .buttonStyle(.bordered)
                                            .clipShape(Circle())
                                            .tint(BrandColors.BrandMain)
                                            .padding()
                                        }
                                }

                            if photoIsSelected {
                                Button {
                                    selectedPhoto = nil
                                    todoTemp.image = nil
                                    withAnimation(.smooth(duration: 0.3)) {
                                        photoIsSelected = false
                                    }
                                } label: {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(.red)
                                }
                                .transition(.blurReplace.combined(with: .opacity))
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(height: 52)
                .background(
                    BrandColors.Gray50,
                    in: RoundedRectangle(cornerRadius: 24, style: .continuous)
                )
                
                
                Toggle("Done with this task?", isOn: $todoTemp.isCompleted)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                
                if !categoriesQuery.isEmpty {
                    ScrollView(showsIndicators: false) {
//                        Text("\(todoObj.categoryCount)") // you can use it like this
                        FlowLayout {
                            ForEach(categoriesQuery) { category in
                                Pills(
                                    name: category.name,
                                    colorCode: category.colorCode,
                                    isSelected: selectedCategoryIDs.contains(category.persistentModelID)
                                ) {
                                    toggleSelection(category)
                                }
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .frame(height: 200)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                    .overlay(alignment: .bottom) {
                        VStack {
                            
                        }
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(BrandColors.Gray0, in: Rectangle())
                        .padding(.bottom, 8)
                        .blur(radius: 16, opaque: false)
                    }
                }
                
                MainButton(label: "Update", fillContainer: true, disabled: todoTemp.title.isEmpty) {
                    withAnimation(.smooth(duration: 0.3)) {
                        todoObj.title = todoTemp.title
                        todoObj.timeStamp = todoTemp.timeStamp
                        todoObj.isCritical = todoTemp.isCritical
                        todoObj.isCompleted = todoTemp.isCompleted
                        todoObj.categories = categoriesQuery.filter {
                            selectedCategoryIDs.contains($0.persistentModelID)
                        }
                        todoObj.image = todoTemp.image
                    }
                    dismiss()
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Your To-do")
            .animation(.easeOut, value: todoObj.isCompleted)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            todoTemp.title = todoObj.title
            todoTemp.timeStamp = todoObj.timeStamp
            todoTemp.isCritical = todoObj.isCritical
            todoTemp.isCompleted = todoObj.isCompleted
            todoTemp.image = todoObj.image
            
            // if there's a photo when the view shows
            if todoObj.image != nil {
                photoIsSelected = true
            }
        }
        .task(id: selectedPhoto) {
            // if this changes
            if let data = try? await selectedPhoto?.loadTransferable(
                type: Data.self
            ) {
                todoTemp.image = data
                withAnimation(.smooth(duration: 0.3).delay(0.5)) {
                    photoIsSelected = true
                }
            }
            
        }
        .animation(.smooth(duration: 0.2), value: todoTemp.image)
    }
    
    private func toggleSelection(_ category: Categories) {
        if selectedCategoryIDs.contains(category.persistentModelID) {
            selectedCategoryIDs.remove(category.persistentModelID)
        } else {
            selectedCategoryIDs.insert(category.persistentModelID)
        }
    }
}

#Preview {
    ToDoDetail(todoObj: .init())
}


// added this struct to prevent immediate update of the task when editing
// data will be stored in this struct until you press the button to update
struct ToDoTemp {
    var title : String
    var timeStamp : Date
    var isCritical : Bool
    var isCompleted : Bool
    var image : Data?
    
    static var example : ToDoTemp {
        ToDoTemp(title: "", timeStamp: .init(), isCritical: false, isCompleted: false, image: nil)
    }
}
