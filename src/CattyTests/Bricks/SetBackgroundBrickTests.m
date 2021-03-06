/**
 *  Copyright (C) 2010-2018 The Catrobat Team
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
#import "AbstractBrickTests.h"
#import "WhenScript.h"
#import "Pocket_Code-Swift.h"

@interface SetBackgroundBrickTests : AbstractBrickTests
@end

@implementation SetBackgroundBrickTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetBackgroundBrick
{
    SpriteObject *object = [[SpriteObject alloc] init];
    Program *program = [Program defaultProgramWithName:@"a" programID:nil];
    CBSpriteNode *spriteNode = [[CBSpriteNode alloc] initWithSpriteObject:object];
    object.spriteNode = spriteNode;
    object.program = program;
    
    SpriteObject *backgroundObject = (SpriteObject*)program.objectList.firstObject;
    XCTAssertNotNil(backgroundObject);
    
    CBSpriteNode *bgSpriteNode = [[CBSpriteNode alloc] initWithSpriteObject:object];
    backgroundObject.spriteNode = bgSpriteNode;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString * filePath = [bundle pathForResource:@"test.png" ofType:nil];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:filePath]);
    Look *look = [[Look alloc] initWithName:@"test" andPath:@"test.png"];
    [imageData writeToFile:[NSString stringWithFormat:@"%@images/%@", [object projectPath], @"test.png"]atomically:YES];
    Look *look1 = [[Look alloc] initWithName:@"test2" andPath:@"test2.png"];
    [imageData writeToFile:[NSString stringWithFormat:@"%@images/%@", [object projectPath], @"test2.png"]atomically:YES];

    Script *script = [[WhenScript alloc] init];
    script.object = object;
//        NextLookBrick *brick = [[NextLookBrick alloc] init];
    SetBackgroundBrick *brick = [[SetBackgroundBrick alloc] init];
    brick.script = script;
    brick.look = look1;
    
    [object.lookList addObject:look];
    [object.lookList addObject:look1];
    
    dispatch_block_t action = [brick actionBlock];
    action();
    
    XCTAssertEqual(backgroundObject.spriteNode.currentLook, look1, @"SetBackgroundBrick not correct");
    [Program removeProgramFromDiskWithProgramName:program.header.programName programID:program.header.programID];
}

@end
