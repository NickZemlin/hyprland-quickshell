import Quickshell

import "root:/Modules/Bar" as Bar
import "root:/Modules/Wallpaper" as Wallpaper

ShellRoot {
    id: root
    property bool enableBar: true
    property bool enableWallpaper: true

    LazyLoader {
        active: root.enableBar

        component: Bar.Bar {}
    }

    LazyLoader {
        active: root.enableWallpaper

        component: Wallpaper.WallpaperWindow {}
    }
}
