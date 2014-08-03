//
//  WSBloomFilter.m
//  WaSPV
//
//  Created by Davide De Rosa on 01/07/14.
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

#import "WSBloomFilter.h"
#import "WSPublicKey.h"
#import "WSAddress.h"
#import "WSTransactionOutPoint.h"

@interface WSBloomFilter ()

@property (nonatomic, strong) WSBIP37Filter *filter;

@end

@implementation WSBloomFilter

- (instancetype)initWithParameters:(WSBIP37FilterParameters *)parameters capacity:(NSUInteger)capacity
{
    if ((self = [super init])) {
        self.filter = [[WSBIP37Filter alloc] initWithParameters:parameters capacity:capacity];
    }
    return self;
}

- (instancetype)initWithFullMatch
{
    if ((self = [super init])) {
        self.filter = [[WSBIP37Filter alloc] initWithFullMatch];
    }
    return self;
}

- (instancetype)initWithNoMatch
{
    if ((self = [super init])) {
        self.filter = [[WSBIP37Filter alloc] initWithNoMatch];
    }
    return self;
}

- (BOOL)containsData:(NSData *)data
{
    return [self.filter containsData:data];
}

- (BOOL)containsPublicKey:(WSPublicKey *)pubKey
{
    return [self.filter containsData:[pubKey encodedData]];
}

- (BOOL)containsAddress:(WSAddress *)address
{
    return [self.filter containsData:address.hash160];
}

- (BOOL)containsUnspent:(WSTransactionOutPoint *)unspent
{
    return [self.filter containsData:[[unspent toBuffer] data]];
}

- (NSString *)description
{
    return [self.filter description];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    WSBloomFilter *copy = [[self class] allocWithZone:zone];
    copy.filter = [self.filter copyWithZone:zone];
    return copy;
}

#pragma mark NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone
{
    WSMutableBloomFilter *copy = [[WSMutableBloomFilter alloc] init];
    copy.filter = [self.filter copyWithZone:zone];
    return copy;
}

#pragma mark WSBufferEncoder

- (void)appendToMutableBuffer:(WSMutableBuffer *)buffer
{
    [self.filter appendToMutableBuffer:buffer];
}

- (WSBuffer *)toBuffer
{
    return [self.filter toBuffer];
}

@end

#pragma mark -

@implementation WSMutableBloomFilter

- (void)insertData:(NSData *)data
{
    [self.filter insertData:data];
}

- (void)insertPublicKey:(WSPublicKey *)pubKey
{
    [self.filter insertData:[pubKey encodedData]];
}

- (void)insertAddress:(WSAddress *)address
{
    [self.filter insertData:address.hash160];
}

- (void)insertUnspent:(WSTransactionOutPoint *)unspent
{
    [self.filter insertData:[[unspent toBuffer] data]];
}

@end