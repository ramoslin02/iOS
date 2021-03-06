/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
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

#import "ORLabel_Private.h"
#import "ORWidget_Private.h"

NSString const *kORLabelTextValueChanged = @"kORLabelTextValueChanged";

#define kTextKey       @"Text"
#define kTextColorKey  @"TextColor"
#define kFontNameKey   @"FontName"
#define kFontSizeKey   @"FontSize"

@implementation ORLabel

// In future version, might want to have an API to indicate if the label should be updated or not
// e.g. in the current iOS console, only sensors for currently displayed widgets are polled


- (instancetype)initWithIdentifier:(ORObjectIdentifier *)anIdentifier text:(NSString *)someText
{
    self = [super initWithIdentifier:anIdentifier];
    if (self) {
        self.text = someText;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont fontWithName:@"Arial" size:14.0];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.text forKey:kTextKey];
    [aCoder encodeObject:self.textColor forKey:kTextColorKey];
    [aCoder encodeObject:self.font.fontName forKey:kFontNameKey];
    [aCoder encodeFloat:self.font.pointSize forKey:kFontSizeKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.text = [aDecoder decodeObjectForKey:kTextKey];
        self.textColor = [aDecoder decodeObjectForKey:kTextColorKey];
        self.font = [UIFont fontWithName:[aDecoder decodeObjectForKey:kFontNameKey]
                                    size:[aDecoder decodeFloatForKey:kFontSizeKey]];
    }
    return self;
}

@end