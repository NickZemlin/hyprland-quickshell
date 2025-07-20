pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
    property var papers :  [
        // TODO: add to README.MD and inline docs
        {
            path: "root:/Assets/green.jpeg",
            name: "green",
            activeBorderColor: "rgba(33ccffee) rgba(00ff99ee) 45deg",
            inactiveBorderColor: "rgba(595959aa)"
        },
        {
            path: "root:/Assets/anime_skull.png",
            name: "animeSkull"
        }
    ]
}