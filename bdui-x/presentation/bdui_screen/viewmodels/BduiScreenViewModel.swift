//
//  BduiScreenViewModel.swift
//  bdui-x
//
//  Created by dark type on 30.09.2025.
//


import Foundation

@MainActor
final class BduiScreenViewModel: ObservableObject {
    @Published var state: ViewState<RenderedScreenResponseModel> = .loading

    private let interactor: BduiInteractor
    private let screenId: String
    private let params: [String: JSONValue]

    init(interactor: BduiInteractor,
         screenId: String,
         params: [String: JSONValue]) {
        self.interactor = interactor
        self.screenId = screenId
        self.params = params
    }

    func load() {
        Task {
            state = .loading
            state = await interactor.loadScreen(screenId: screenId, params: params)
        }
    }
}
