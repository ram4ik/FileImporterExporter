//
//  ContentView.swift
//  FileImporterExporter
//
//  Created by Ramill Ibragimov on 29.08.2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var fileName = ""
    @State private var openFile = false
    @State private var saveFile = false
    
    var body: some View {
        VStack(spacing: 25) {
            
            Text(fileName)
                .fontWeight(.bold)
            
            Button(action: {openFile.toggle()}, label: {
                Text("Open")
            })
            Button(action: {saveFile.toggle()}, label: {
                Text("Save")
            })
        }
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf]) { (res) in
            do {
                let fileUrl = try res.get()
                print(fileUrl)
                
                self.fileName = fileUrl.lastPathComponent
            } catch {
                print("Error reading docs")
                print(error.localizedDescription)
            }
        }
        .fileExporter(isPresented: $saveFile, document: Doc(url: Bundle.main.path(forResource: "woman", ofType: "png")!), contentType: .audio) { (res) in
            do {
                let fileUrl = try res.get()
                print(fileUrl)
            }
            catch {
                print("cannot save doc")
                print(error.localizedDescription)
            }
        }
    }
}

struct Doc: FileDocument {
    var url: String
    static var readableContentTypes: [UTType]{[.audio]}
    
    init(url: String) {
        self.url = url
    }
    
    init(configuration: ReadConfiguration) throws {
        url = ""
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let file = try! FileWrapper(url: URL(fileURLWithPath: url), options: .immediate)
        
        return file
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
