//
//  KiiThingOwner.h
//  KiiSDK-Private
//
//  Created by Syah Riza on 12/18/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A protocol to represent the owner of thing.
 */
@protocol KiiThingOwner <NSObject>
@required
/**An identifier of thing owner, it can be <KiiUser> or <KiiGroup> id.
 @return <[KiiUser userID]> or <[KiiGroup groupID]> that own the thing.
 */
-(NSString*) thingOwnerID;
@end
