//
//  WSBlockHeader.h
//  WaSPV
//
//  Created by Davide De Rosa on 24/06/14.
//  Copyright (c) 2014 Davide De Rosa. All rights reserved.
//
//  http://github.com/keeshux
//  http://twitter.com/keeshux
//  http://davidederosa.com
//
//  This file is part of WaSPV.
//
//  WaSPV is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  WaSPV is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with WaSPV.  If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>

#import "WSBuffer.h"
#import "WSIndentableDescription.h"

@class WSCheckpoint;

@interface WSBlockHeader : NSObject <NSCopying, WSBufferEncoder, WSBufferDecoder, WSIndentableDescription>

- (instancetype)initWithVersion:(uint32_t)version
                previousBlockId:(WSHash256 *)previousBlockId
                     merkleRoot:(WSHash256 *)merkleRoot
                      timestamp:(uint32_t)timestamp
                           bits:(uint32_t)bits
                          nonce:(uint32_t)nonce;

// WARNING: isComplete fails after this, cannot compute block id
- (instancetype)initWithCheckpoint:(WSCheckpoint *)checkpoint previousBlockId:(WSHash256 *)previousBlockId;

- (uint32_t)version;
- (WSHash256 *)previousBlockId;
- (WSHash256 *)merkleRoot;
- (uint32_t)timestamp; // UNIX timestamp in seconds
- (uint32_t)bits;
- (uint32_t)nonce;
- (uint32_t)txCount;

- (BOOL)isComplete;
- (WSHash256 *)blockId;
- (NSData *)difficultyData;
- (NSString *)difficultyString;
- (NSData *)workData;
- (NSString *)workString;
- (BOOL)verifyWithError:(NSError **)error;

@end