//
//  SpecificationKeys.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/11/2022.
//

import Foundation
import texterify_ios_sdk

enum SpecificationKeys: String {
    case processor
    case ramMemory
    case massStorage
    case displayType
    case displaySize
    case displayResolution
    case pixelDensity
    case refreshRate
    case displayBrightness
    case cameraPhotoResolutionFront
    case cameraPhotoResolutionBack
    case cameraZoomBack
    case cameraVideoResolutionBack
    case connectivity
    case inputs
    case fingerprintReader
    case faceReader
    case operatingSystem
    case weight
    case additionalInfo
    
    var rawValue: String {
        switch self {
        case .processor:
            return TexterifyManager.localisedString(key: .specificationKeys(.processor))
        case .ramMemory:
            return TexterifyManager.localisedString(key: .specificationKeys(.ramMemory))
        case .massStorage:
            return TexterifyManager.localisedString(key: .specificationKeys(.massStorage))
        case .displayType:
            return TexterifyManager.localisedString(key: .specificationKeys(.displayType))
        case .displaySize:
            return TexterifyManager.localisedString(key: .specificationKeys(.displaySize))
        case .displayResolution:
            return TexterifyManager.localisedString(key: .specificationKeys(.displayResolution))
        case .pixelDensity:
            return TexterifyManager.localisedString(key: .specificationKeys(.pixelDensity))
        case .refreshRate:
            return TexterifyManager.localisedString(key: .specificationKeys(.refreshRate))
        case .displayBrightness:
            return TexterifyManager.localisedString(key: .specificationKeys(.displayBrightness))
        case .cameraPhotoResolutionFront:
            return TexterifyManager.localisedString(key: .specificationKeys(.cameraPhotoResolutionFront))
        case .cameraPhotoResolutionBack:
            return TexterifyManager.localisedString(key: .specificationKeys(.cameraPhotoResolutionBack))
        case .cameraZoomBack:
            return TexterifyManager.localisedString(key: .specificationKeys(.cameraZoomBack))
        case .cameraVideoResolutionBack:
            return TexterifyManager.localisedString(key: .specificationKeys(.cameraVideoResolutionBack))
        case .connectivity:
            return TexterifyManager.localisedString(key: .specificationKeys(.connectivity))
        case .inputs:
            return TexterifyManager.localisedString(key: .specificationKeys(.inputs))
        case .fingerprintReader:
            return TexterifyManager.localisedString(key: .specificationKeys(.fingerprintReader))
        case .faceReader:
            return TexterifyManager.localisedString(key: .specificationKeys(.faceReader))
        case .operatingSystem:
            return TexterifyManager.localisedString(key: .specificationKeys(.operatingSystem))
        case .weight:
            return TexterifyManager.localisedString(key: .specificationKeys(.weight))
        case .additionalInfo:
            return TexterifyManager.localisedString(key: .specificationKeys(.additionalInfo))
        }
    }
    
    var decodeValue: String {
        switch self {
        case .processor:
            return "Processor"
        case .ramMemory:
            return "RAM Memory"
        case .massStorage:
            return "Mass Storage"
        case .displayType:
            return "Display Type"
        case .displaySize:
            return "Display Size"
        case .displayResolution:
            return "Display Resolution"
        case .pixelDensity:
            return "Pixel Density"
        case .refreshRate:
            return "Refresh Rate"
        case .displayBrightness:
            return "DisplayBrightness"
        case .cameraPhotoResolutionFront:
            return "Camera Photo Resolution (Front)"
        case .cameraPhotoResolutionBack:
            return "Camera Photo Resolution (Back)"
        case .cameraZoomBack:
            return "Camera Zoom (Back)"
        case .cameraVideoResolutionBack:
            return "Camera Video Resolution (Back)"
        case .connectivity:
            return "Connectivity"
        case .inputs:
            return "Inputs"
        case .fingerprintReader:
            return "Fingerprint Reader"
        case .faceReader:
            return "Face Reader"
        case .operatingSystem:
            return "Operating System"
        case .weight:
            return "Weight"
        case .additionalInfo:
            return "Additional Info"
        }
    }
}

extension SpecificationKeys {
    static var allCases: [SpecificationKeys] {
        return [.processor,
                .ramMemory,
                .massStorage,
                .displayType,
                .displaySize,
                .displayResolution,
                .pixelDensity,
                .refreshRate,
                .displayBrightness,
                .cameraPhotoResolutionFront,
                .cameraPhotoResolutionBack,
                .cameraZoomBack,
                .cameraVideoResolutionBack,
                .connectivity,
                .inputs,
                .fingerprintReader,
                .faceReader,
                .operatingSystem,
                .weight,
                .additionalInfo]
    }
}

extension SpecificationKeys {
    static func withLabel(_ label: String) -> SpecificationKeys? {
        return self.allCases.first { "\($0.decodeValue)" == label }
    }
}
