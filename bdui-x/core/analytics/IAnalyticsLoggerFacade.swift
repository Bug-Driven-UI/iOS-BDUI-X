//
//  IAnalyticsLoggerFacade.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


public protocol IAnalyticsLoggerFacade {
    func logScreenRendered(
        screenName: String,
        screenVersion: Int,
        componentsCount: Int,
        renderTimeMs: Int64
    )

    func logScreenShown(
        screenName: String
    )

    func logScreenUpdated(
        screenName: String,
        updatedComponentsCount: Int,
        updateDurationMs: Int64
    )

    func logComponentClicked(
        screenName: String,
        componentId: String
    )

    func logUserNavigated(
        fromScreenName: String,
        toScreenName: String?,
        method: AnalyticsNavigationMethod
    )

    func logErrorScreenShown(
        screenName: String
    )

    func logErrorSnackbarShown(
        screenName: String,
        message: String?
    )
}
