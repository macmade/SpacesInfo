/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2025, Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the Software), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Foundation

guard let libraryURL = NSSearchPathForDirectoriesInDomains( .libraryDirectory, .userDomainMask, true ).first
else
{
    fatalError( "Unable to locate the user's Library folder." )
}

let plistURL = URL( fileURLWithPath: libraryURL ).appendingPathComponent( "Preferences/com.apple.spaces.plist" )

guard FileManager.default.fileExists( atPath: plistURL.path )
else
{
    fatalError( "The Spaces preferences file does not exist." )
}

guard let plistData = try? Data( contentsOf: plistURL )
else
{
    fatalError( "Unable to read the Spaces preferences file." )
}

guard let plist = try? PropertyListSerialization.propertyList( from: plistData, options: [], format: nil ) as? [ String: Any ]
else
{
    fatalError( "Unable to parse the Spaces preferences file." )
}

guard let apps: [ String: String ] = plist[ "app-bindings" ] as? [ String: String ]
else
{
    fatalError( "Unable to locate the app-bindings dictionary." )
}

guard let configuration = plist[ "SpacesDisplayConfiguration" ] as? [ String: Any ]
else
{
    fatalError( "Unable to locate the SpacesDisplayConfiguration dictionary." )
}

guard let properties = configuration[ "Space Properties" ] as? [ [ String: Any ] ]
else
{
    fatalError( "Unable to locate the Space Properties array." )
}

guard let managementData = configuration[ "Management Data" ] as? [ String: Any ]
else
{
    fatalError( "Unable to locate the Management Dara dictionary." )
}

guard let monitors = managementData[ "Monitors" ] as? [ [ String: Any ] ]
else
{
    fatalError( "Unable to locate the Monitors dictionary." )
}

guard let monitor = monitors.first
else
{
    fatalError( "Unable to locate the Monitors dictionary." )
}

guard let spaces = monitor[ "Spaces" ] as? [ [ String: Any ] ]
else
{
    fatalError( "Unable to locate the Spaces dictionary." )
}

spaces.enumerated().forEach
{
    guard let uuid = $0.element[ "uuid" ] as? String
    else
    {
        return
    }

    print( "Space \( $0.offset + 1 ): \( uuid )" )

    apps.keys.forEach
    {
        let space = apps[ $0 ]

        if space == uuid
        {
            print( "    - \( $0 )" )
        }
    }
}
