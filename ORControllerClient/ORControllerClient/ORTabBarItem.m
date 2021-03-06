/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#import "ORTabBarItem_Private.h"
#import "ORLabel_Private.h"

#define kLabelKey       @"Label"
#define kImageKey       @"Image"
#define kNavigationKey  @"Navigation"

@interface ORTabBarItem ()

@property (nonatomic, strong, readwrite) ORLabel *label;

@end

@implementation ORTabBarItem

- (instancetype)initWithText:(NSString *)someText
{
    self = [super init];
    if (self) {
        self.label = [[ORLabel alloc] initWithIdentifier:nil text:someText];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.label forKey:kLabelKey];
    [aCoder encodeObject:self.image forKey:kImageKey];
    [aCoder encodeObject:self.navigation forKey:kNavigationKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.label = [aDecoder decodeObjectForKey:kLabelKey];
        self.image = [aDecoder decodeObjectForKey:kImageKey];
        self.navigation = [aDecoder decodeObjectForKey:kNavigationKey];
    }
    return self;
}

@synthesize label, navigation, image;

@end