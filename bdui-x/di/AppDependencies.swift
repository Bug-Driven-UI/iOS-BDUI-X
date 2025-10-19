//
//  AppDependencies.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import Foundation

import Foundation
import Alamofire

public struct AppDependencies {
    public let snackbarManager: SnackbarManager

    public let navigationManager: NavigationManager
    public let navigationResults: NavigationResultStore

    public let resources: IResourcesWrapper
    public let analyticsLogger: IAnalyticsLogger
    public let analytics: IAnalyticsLoggerFacade

    public let bduiApi: BduiApi
    public let bduiScreenRepository: IBduiScreenRepository
    public let interactor: IBduiInteractor

    public init(
        snackbarManager: SnackbarManager,
        navigationManager: NavigationManager,
        navigationResults: NavigationResultStore,
        resources: IResourcesWrapper,
        analyticsLogger: IAnalyticsLogger,
        analytics: IAnalyticsLoggerFacade,
        bduiApi: BduiApi,
        bduiScreenRepository: IBduiScreenRepository,
        interactor: IBduiInteractor
    ) {
        self.snackbarManager = snackbarManager
        self.navigationManager = navigationManager
        self.navigationResults = navigationResults
        self.resources = resources
        self.analyticsLogger = analyticsLogger
        self.analytics = analytics
        self.bduiApi = bduiApi
        self.bduiScreenRepository = bduiScreenRepository
        self.interactor = interactor
    }
}

public extension AppDependencies {
    private static func makeDefault() -> (
        snackbarManager: SnackbarManager,
        navigationManager: NavigationManager,
        navigationResults: NavigationResultStore,
        resources: IResourcesWrapper,
        bduiApi: BduiApi,
        bduiScreenRepository: IBduiScreenRepository,
        interactor: IBduiInteractor
    ) {
        let baseURL = URL(string: DataConstants.baseUrl)!
        let snackbarManager = SnackbarManager()
        let navigationManager = NavigationManager()
        let navigationResults = NavigationResultStore()
        let resources = ResourcesWrapper()
        


        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(DataConstants.timeoutSeconds)
        config.timeoutIntervalForResource = TimeInterval(DataConstants.timeoutSeconds)
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let session = Session(configuration: config)
        let api: BduiApi = BduiApiAF(baseURL: baseURL, session: session)
        let repo: IBduiScreenRepository = BduiScreenRepository(api: api)
        let interactor: IBduiInteractor = BduiInteractor(bduiScreenRepository: repo)

        return (snackbarManager, navigationManager, navigationResults, resources, api, repo, interactor)
    }

    static func makeProduction() -> AppDependencies {
        let common = makeDefault()
        let analyticsLogger = FirebaseAnalyticsLogger()
        let analytics = AnalyticsLoggerFacade(analyticsLogger: analyticsLogger)

        return AppDependencies(
            snackbarManager: common.snackbarManager,
            navigationManager: common.navigationManager,
            navigationResults: common.navigationResults,
            resources: common.resources,
            analyticsLogger: analyticsLogger,
            analytics: analytics,
            bduiApi: common.bduiApi,
            bduiScreenRepository: common.bduiScreenRepository,
            interactor: common.interactor
        )
    }
}
