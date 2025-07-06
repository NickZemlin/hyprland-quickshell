pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
    property var papers :  [
        {
            path: "root:/Assets/green.jpeg",
            name: "green"
        },
        {
            path: "root:/Assets/anime_skull.png",
            name: "animeSkull"
        }
    ]

    component Paper: QtObject {
        property var path
        property var name
    }
}