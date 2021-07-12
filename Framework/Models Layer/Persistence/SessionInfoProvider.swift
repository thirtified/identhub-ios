//
//  SessionInfoProvider.swift
//  IdentHubSDK
//

import Foundation

/// Describes entity capable of providing information about the session.
protocol SessionInfoProvider: AnyObject {

    /// Session token which contains partner id, client id and session id.
    var sessionToken: String { get set }

    /// Mobile number of the current user.
    var mobileNumber: String? { get set }

    /// Id of the identification.
    var identificationUID: String? { get set }

    /// Path to the payment identification provider.
    var identificationPath: String? { get set }

    /// Successful identification status
    var isSuccessful: Bool? { get set }

    /// Identification step type
    var identificationStep: IdentificationStep? { get set }

    /// Fallback identification step type
    var fallbackIdentificationStep: IdentificationStep? { get set }

    /// IBAN retries count
    var retries: Int { get set }

    /// Documents list
    var documentsList: [SupportedDocument]? { get set }

    /// Clears currently stored data.
    func clear()
}

/// Count of default retries. Used if from server comes null value
let defaultRetries = 5

/// Session info provider.
final class StorageSessionInfoProvider: SessionInfoProvider {

    // MARK: Properties

    /// - SeeAlso: SessionInfoProvider.sessionToken
    var sessionToken: String

    /// - SeeAlso: SessionInfoProvider.mobileNumber
    var mobileNumber: String? {
        didSet {
            SessionStorage.updateValue(mobileNumber!, for: StoredKeys.mobileNumber.rawValue)
        }
    }

    /// - SeeAlso: SessionInfoProvider.identificationUID
    var identificationUID: String? {
        didSet {
            SessionStorage.updateValue(identificationUID!, for: StoredKeys.identUID.rawValue)
        }
    }

    /// - SeeAlso: SessionInfoProvider.identificationPath
    var identificationPath: String? {
        didSet {
            SessionStorage.updateValue(identificationPath!, for: StoredKeys.identPath.rawValue)
        }
    }

    /// - SeeAlso: SessionInfoProvider.fallbackIdentificationStep
    var fallbackIdentificationStep: IdentificationStep? {
        didSet {
            if let step = fallbackIdentificationStep {
                SessionStorage.updateValue(step.rawValue, for: StoredKeys.fallbackIdentStep.rawValue)
            }
        }
    }

    /// - SeeAlso: SessionInfoProvider.fallbackIdentificationStep
    var retries: Int = defaultRetries {
        didSet {
            SessionStorage.updateValue(retries, for: StoredKeys.retriesCount.rawValue)
        }
    }

    /// - SeeAlso: SessionInfoProvider.isSuccessful
    var isSuccessful: Bool?

    /// - SeeAlso: SessionInfoProvider.identificationType
    var identificationStep: IdentificationStep?

    /// - SeeAlso: SessionInfoProvider.documentsList
    var documentsList: [SupportedDocument]?

    // MARK: Init

    init(sessionToken: String) {
        self.sessionToken = sessionToken
        self.restoreValues()
    }

    /// - SeeAlso: SessionInfoProvider.clear()
    func clear() {
        sessionToken = ""
        mobileNumber = nil
        identificationUID = nil
        identificationPath = nil
        isSuccessful = false

        SessionStorage.clearData()
    }
}

// MARK: - Private methods -

private extension StorageSessionInfoProvider {

    private func restoreValues() {

        if let token = SessionStorage.obtainValue(for: StoredKeys.token.rawValue) as? String {
            if sessionToken != token {
                SessionStorage.clearData()
                return
            }
        } else {
            SessionStorage.clearData()
            SessionStorage.updateValue(sessionToken, for: StoredKeys.token.rawValue)
            return
        }

        if let number = SessionStorage.obtainValue(for: StoredKeys.mobileNumber.rawValue) as? String {
            mobileNumber = number
        }

        if let uid = SessionStorage.obtainValue(for: StoredKeys.identUID.rawValue) as? String {
            identificationUID = uid
        }

        if let path = SessionStorage.obtainValue(for: StoredKeys.identPath.rawValue) as? String {
            identificationPath = path
        }

        if let fallbackStep = SessionStorage.obtainValue(for: StoredKeys.fallbackIdentStep.rawValue) as? String {
            fallbackIdentificationStep = IdentificationStep(rawValue: fallbackStep)
        }

        if let retriesCount = SessionStorage.obtainValue(for: StoredKeys.retriesCount.rawValue) as? Int {
            retries = retriesCount
        }
    }
}
