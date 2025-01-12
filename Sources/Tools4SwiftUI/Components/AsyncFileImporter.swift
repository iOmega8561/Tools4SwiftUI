//
//  AsyncFileImporter.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

import SwiftUI

import UniformTypeIdentifiers

public struct AsyncFileImporter: ViewModifier {
    
    private let allowedContentTypes: [UTType]
    
    private let completionHandler: ([URL]) async throws -> Void
    
    private let allowsMultipleSelection: Bool
    
    @Binding private var isPresented: Bool
    
    @State private var isExecuting: Bool = false
    
    #if !os(macOS)
    /// Tracks whether an error has been encountered
    ///
    /// This state variable determines whether the async task has encountered an error and stores it until dismission
    /// - Note: This is available only on platforms where `AppKit` is not available (everything but macOS)
    @State private var currentError: Error? = nil
    #endif
    
    public func body(content: Content) -> some View {
        content
            .disabled(isExecuting)
            .fileImporter(
                isPresented: $isPresented,
                allowedContentTypes: allowedContentTypes,
                allowsMultipleSelection: allowsMultipleSelection
            ) { result in
                
                switch result {
                case .success(let files):
                    isExecuting = true
                    
                    Task(priority: .userInitiated) { @MainActor in
                        
                        files.forEach { file in
                            _ = file.startAccessingSecurityScopedResource()
                        }
                        
                        do {
                            try await completionHandler(files)
                        } catch {
                            #if !os(macOS)
                            currentError = error
                            #else
                            NSAlert.displayError(error)
                            #endif
                        }
                        
                        files.forEach { file in
                            file.stopAccessingSecurityScopedResource()
                        }
                        
                        isExecuting = false
                    }
                case .failure: return
                }
            }
            #if !os(macOS)
            .errorAlert(currentError: $currentError)
            #endif
    }
    
    public init(
        isPresented: Binding<Bool>,
        allowedContentTypes: [UTType],
        allowsMultipleSelection: Bool = false,
        completionHandler: @escaping ([URL]) async throws -> Void
    ) {
        self.allowedContentTypes = allowedContentTypes
        self.completionHandler = completionHandler
        self.allowsMultipleSelection = allowsMultipleSelection
        _isPresented = isPresented
    }
    
    public init(
        isPresented: Binding<Bool>,
        allowedContentType: UTType,
        allowsMultipleSelection: Bool = false,
        completionHandler: @escaping ([URL]) async throws -> Void
    ) {
        self.allowedContentTypes = [allowedContentType]
        self.completionHandler = completionHandler
        self.allowsMultipleSelection = allowsMultipleSelection
        _isPresented = isPresented
    }
}
