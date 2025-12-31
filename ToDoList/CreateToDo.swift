//
//  CreateToDo.swift
//  ToDoList
//
//  Created by Gdwn16 on 03/12/2025.
//

import SwiftData
import SwiftUI
import SwiftUIImageViewer
import PhotosUI  // lets you pick a photo stored on your device

struct CreateToDo: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query(sort: \Categories.created, order: .reverse) private
        var categoriesQuery: [Categories]
    @State private var item = TodoItem()
    @State private var selectedCategoryIDs: Set<PersistentIdentifier> = []
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoIsSelected: Bool = false
    @State private var isImagePresented: Bool = false

    let tappedCreateButton: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                TextField("Name", text: $item.title)
                    .padding()
                    .padding(.horizontal, 4)
                    .background(
                        BrandColors.Gray50,
                        in: RoundedRectangle(cornerRadius: 24)
                    )
                DatePicker("Date", selection: $item.timeStamp)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        BrandColors.Gray50,
                        in: RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        )
                    )
                Toggle("Important", isOn: $item.isCritical)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        BrandColors.Gray50,
                        in: RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        )
                    )

                // photo picker
                HStack {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack {
                            Image(
                                systemName: item.image == nil
                                    ? "plus" : "pencil"
                            )
                            Text(
                                item.image == nil
                                    ? "Tap to add photo" : "Change photo"
                            )
                            .fontWeight(.medium)
                        }
                        .foregroundStyle(
                            item.image == nil ? .gray : BrandColors.BrandMain
                        )

                    }
                    Spacer()
                    if let imageData = item.image,
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
                                    item.image = nil
                                    withAnimation(.smooth(duration: 0.3)) {
                                        photoIsSelected = false
                                    }
                                } label: {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(.red)
                                }
                                .transition(
                                    .blurReplace.combined(with: .opacity)
                                )
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

                if !categoriesQuery.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Where do these fall under?")
                            .foregroundStyle(BrandColors.Gray500)
                            .padding(.vertical)
                        ScrollView(showsIndicators: false) {
                            FlowLayout {
                                ForEach(categoriesQuery) { category in
                                    Pills(
                                        name: category.name,
                                        colorCode: category.colorCode,
                                        isSelected:
                                            selectedCategoryIDs.contains(
                                                category.persistentModelID
                                            )
                                    ) {
                                        toggleSelection(category)
                                    }
                                    //
                                }
                            }
                            .padding(.bottom, 24)
                        }
                        .frame(height: 200)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        BrandColors.Gray0,
                        in: RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        )
                    )
                }

                MainButton(
                    label: "Create",
                    fillContainer: true,
                    disabled: item.title.isEmpty
                ) {
                    item.categories = categoriesQuery.filter {
                        selectedCategoryIDs.contains($0.persistentModelID)
                    }
                    withAnimation {
                        context.insert(item)
                        tappedCreateButton()
                    }
                    dismiss()
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Create To Do")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .task(id: selectedPhoto) {
            // what should happen when id changes?
            if let data = try? await selectedPhoto?.loadTransferable(
                type: Data.self
            ) {
                item.image = data
                withAnimation(.smooth(duration: 0.3).delay(0.5)) {
                    photoIsSelected = true
                }
            }
        }
        .animation(.smooth(duration: 0.2), value: item.image)
    }

    // check whether the selected category exists in the set
    private func toggleSelection(_ category: Categories) {
        if selectedCategoryIDs.contains(category.persistentModelID) {
            selectedCategoryIDs.remove(category.persistentModelID)
        } else {
            selectedCategoryIDs.insert(category.persistentModelID)
        }
    }
}

#Preview {
    CreateToDo {}
        .modelContainer(for: TodoItem.self)
}
