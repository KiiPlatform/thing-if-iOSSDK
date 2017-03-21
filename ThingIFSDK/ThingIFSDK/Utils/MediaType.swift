//
//  MediaType.swift
//  ThingIFSDK
//
//  Created on 2017/03/06.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

internal enum MediaType : String {
    case mediaTypeOnboardingWithThingIdByOwnerRequest =
           "application/vnd.kii.OnboardingWithThingIDByOwner+json"
    case mediaTypeOnboardingWithVendorThingIdByOwnerRequest = "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
    case mediaTypeOnboardingEndnodeWithGatewayThingIdRequest = "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
    case mediaTypeTraitStateQueryRequest = "application/vnd.kii.TraitStateQueryRequest+json"
    case mediaTypeVendorThingIDUpdateRequest = "application/vnd.kii.VendorThingIDUpdateRequest+json"
    case mediaTypeThingFirmwareVersionUpdateRequest = "application/vnd.kii.ThingFirmwareVersionUpdateRequest+json"
}
