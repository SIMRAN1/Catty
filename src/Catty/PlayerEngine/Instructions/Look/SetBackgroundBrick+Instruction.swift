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

@objc extension SetBackgroundBrick: CBInstructionProtocol {

    @nonobjc func instruction() -> CBInstruction {
        return .action(action: SKAction.run(actionBlock()))
    }

    @objc func actionBlock() -> ()->() {
        guard let object = self.script.object.program.objectList.firstObject as? SpriteObject,
              let spriteNode = object.spriteNode
        else { fatalError("This should never happen!") }

        return {
            let cache:RuntimeImageCache = RuntimeImageCache.shared()
            var image = cache.cachedImage(forPath: self.pathForLook())
            
            if(image == nil){
                print("LoadImageFromDisk")
                cache.loadImageFromDisk(withPath: self.pathForLook())
                guard let imageFromDisk = UIImage(contentsOfFile: self.pathForLook()) else { return }
                image = imageFromDisk
            }

            spriteNode.currentLook = self.look
            spriteNode.executeFilter(image)
        }
    }
}
