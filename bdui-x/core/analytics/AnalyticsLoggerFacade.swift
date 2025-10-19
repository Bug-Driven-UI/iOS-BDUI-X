//
//  AnalyticsLoggerFacade.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//


import Foundation
import os

private let ANALYTICS_LOGGER_TAG = "AnalyticsLogger"

// Event names
private let EVENT_NAME_SCREEN_RENDERED = "screen_rendered"
private let EVENT_NAME_SCREEN_SHOWN = "screen_shown"
private let EVENT_NAME_SCREEN_UPDATED = "screen_updated"
private let EVENT_NAME_COMPONENT_CLICKED = "component_clicked"
private let EVENT_NAME_USER_NAVIGATED = "user_navigated"
private let EVENT_NAME_ERROR_SCREEN_SHOWN = "error_screen_shown"
private let EVENT_NAME_ERROR_SNACKBAR_SHOWN = "error_snackbar_shown"

// Param keys
private let EVENT_PARAM_SCREEN_NAME = "screen_name"
private let EVENT_PARAM_SCREEN_VERSION = "screen_version"
private let EVENT_PARAM_COMPONENTS_COUNT = "components_count"
private let EVENT_PARAM_RENDER_TIME_MS = "render_time_ms"
private let EVENT_PARAM_UPDATED_COMPONENTS_COUNT = "updated_components_count"
private let EVENT_PARAM_UPDATE_DURATION_MS = "update_duration_ms"
private let EVENT_PARAM_COMPONENT_ID = "component_id"
private let EVENT_PARAM_FROM_SCREEN_NAME = "from_screen_name"
private let EVENT_PARAM_TO_SCREEN_NAME = "to_screen_name"
private let EVENT_PARAM_METHOD = "method"
private let EVENT_PARAM_MESSAGE = "message"

private let MAX_MESSAGE_LENGTH = 100
private let UNKNOWN_ERROR_MESSAGE = "unknown_error"

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "app", category: ANALYTICS_LOGGER_TAG)

public final class AnalyticsLoggerFacade: IAnalyticsLoggerFacade {

    private let analyticsLogger: IAnalyticsLogger

    public init(analyticsLogger: IAnalyticsLogger) {
        self.analyticsLogger = analyticsLogger
    }

    public func logScreenRendered(
        screenName: String,
        screenVersion: Int,
        componentsCount: Int,
        renderTimeMs: Int64
    ) {
        analyticsLogger.logEvent(
            eventName: EVENT_NAME_SCREEN_RENDERED,
            params: [
                EVENT_PARAM_SCREEN_NAME: screenName,
                EVENT_PARAM_SCREEN_VERSION: String(screenVersion),
                EVENT_PARAM_COMPONENTS_COUNT: String(componentsCount),
                EVENT_PARAM_RENDER_TIME_MS: String(renderTimeMs)
            ]
        )

        logger.debug("logScreenRendered: screenName=\(screenName), version=\(screenVersion), components=\(componentsCount), renderTimeMs=\(renderTimeMs)")
    }

    public func logScreenShown(screenName: String) {
        analyticsLogger.logEvent(
            eventName: EVENT_NAME_SCREEN_SHOWN,
            params: [
                EVENT_PARAM_SCREEN_NAME: screenName
            ]
        )

        logger.debug("logScreenShown: screenName=\(screenName)")
    }

    public func logScreenUpdated(
        screenName: String,
        updatedComponentsCount: Int,
        updateDurationMs: Int64
    ) {
        analyticsLogger.logEvent(
            eventName: EVENT_NAME_SCREEN_UPDATED,
            params: [
                EVENT_PARAM_SCREEN_NAME: screenName,
                EVENT_PARAM_UPDATED_COMPONENTS_COUNT: String(updatedComponentsCount),
                EVENT_PARAM_UPDATE_DURATION_MS: String(updateDurationMs)
            ]
        )

        logger.debug("logScreenUpdated: screenName=\(screenName), updateCount=\(updatedComponentsCount), updateDurationMs=\(updateDurationMs)")
    }

    public func logComponentClicked(
        screenName: String,
        componentId: String
    ) {
        analyticsLogger.logEvent(
            eventName: EVENT_NAME_COMPONENT_CLICKED,
            params: [
                EVENT_PARAM_SCREEN_NAME: screenName,
                EVENT_PARAM_COMPONENT_ID: componentId
            ]
        )

        logger.debug("logComponentClicked: screenName=\(screenName), componentId=\(componentId)")
    }

    public func logUserNavigated(
        fromScreenName: String,
        toScreenName: String?,
        method: AnalyticsNavigationMethod
    ) {
        analyticsLogger.logEvent(
            eventName: EVENT_NAME_USER_NAVIGATED,
            params: [
                EVENT_PARAM_FROM_SCREEN_NAME: fromScreenName,
                EVENT_PARAM_TO_SCREEN_NAME: toScreenName ?? "",
                EVENT_PARAM_METHOD: method.rawValue
            ]
        )

        logger.debug("logUserNavigated: fromScreenName=\(fromScreenName), toScreenName=\(toScreenName ?? ""), method=\(method.rawValue)")
    }

    public func logErrorScreenShown(screenName: String) {
        analyticsLogger.logEvent(
            eventName: EVENT_NAME_ERROR_SCREEN_SHOWN,
            params: [
                EVENT_PARAM_SCREEN_NAME: screenName
            ]
        )

        logger.debug("logErrorScreenShown: screenName=\(screenName)")
    }

    public func logErrorSnackbarShown(screenName: String, message: String?) {
        let msg = (message ?? UNKNOWN_ERROR_MESSAGE).truncated(to: MAX_MESSAGE_LENGTH)

        analyticsLogger.logEvent(
            eventName: EVENT_NAME_ERROR_SNACKBAR_SHOWN,
            params: [
                EVENT_PARAM_SCREEN_NAME: screenName,
                EVENT_PARAM_MESSAGE: msg
            ]
        )

        logger.debug("logErrorSnackbarShown: screenName=\(screenName), message=\(msg)")
    }
}

private extension String {
    func truncated(to maxLength: Int) -> String {
        guard count > maxLength else { return self }
        return String(prefix(maxLength))
    }
}