/**
 *  Copyright (C) 2010-2014 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

#import <XCTest/XCTest.h>
#import "XMLParserAbstractTest.h"

@interface XMLParserObjectTests : XMLParserAbstractTest

@end

@implementation XMLParserObjectTests

- (void)testValidObjectList {
    
    GDataXMLDocument *document = [self getXMLDocumentForPath:[self getPathForXML:@"ValidProgram"]];
    GDataXMLElement *xmlElement = [document rootElement];
    
    NSArray *objectListElements = [xmlElement elementsForName:@"objectList"];
    XCTAssertEqual([objectListElements count], 1);
    
    NSArray *objectElements = [[objectListElements firstObject] children];
    NSMutableArray *objectList = [NSMutableArray arrayWithCapacity:[objectElements count]];
    
    CBXMLContext *context = [CBXMLContext new];
    for (GDataXMLElement *objectElement in objectElements) {
        SpriteObject *spriteObject = [SpriteObject parseFromElement:objectElement withContext:context];
        [objectList addObject:spriteObject];
    }
    
    XCTAssertEqual([objectList count], 5);
    
    SpriteObject *background = [objectList objectAtIndex:0];
    XCTAssertTrue([background.name isEqualToString: @"Background"], @"SpriteObject[0]: Name not correctly parsed");
    XCTAssertEqual([background.lookList count], 1, @"SpriteObject[0]: lookList not correctly parsed");
    
    Look *look = [background.lookList objectAtIndex:0];
    XCTAssertTrue([look.name isEqualToString: @"Background"], @"SpriteObject[0]: Look name not correctly parsed");
    XCTAssertTrue([look.fileName isEqualToString: @"1f363a1435a9497852285dbfa82b74e4_Background.png"], @"SpriteObject[0]: Look fileName not correctly parsed");
    
    XCTAssertEqual([background.soundList count], 0, @"SpriteObject[0]: soundList not correctly parsed");
    XCTAssertEqual([background.scriptList count], 1, @"SpriteObject[0]: scriptList not correctly parsed");
    
    SpriteObject *mole = [objectList objectAtIndex:1];
    XCTAssertTrue([mole.name isEqualToString: @"Mole 1"], @"SpriteObject[1]: Name not correctly parsed");
    XCTAssertEqual([mole.lookList count], 3, @"SpriteObject[1]: lookList not correctly parsed");
    look = [mole.lookList objectAtIndex:1];
    XCTAssertTrue([look.name isEqualToString: @"Mole"], @"SpriteObject[1]: Look name not correctly parsed");
    XCTAssertTrue([look.fileName isEqualToString: @"dfcefc77af918afcbb71009c12ca5378_Mole.png"], @"SpriteObject[1]: Look fileName not correctly parsed");
    
    XCTAssertEqual([mole.soundList count], 1, @"SpriteObject[1]: soundList not correctly parsed");
    Sound *sound = [mole.soundList objectAtIndex:0];
    XCTAssertTrue([sound.name isEqualToString: @"Hit"], @"SpriteObject[1]: Sound name not correctly parsed");
    XCTAssertTrue([sound.fileName isEqualToString: @"6f231e6406d3554d691f3c9ffb37c043_Hit1.m4a"], @"SpriteObject[1]: Sound fileName not correctly parsed");
}

@end
