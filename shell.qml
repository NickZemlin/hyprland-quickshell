import Quickshell

import "root:/Modules/Bar" as Bar
import "root:/Modules/Wallpaper" as Wallpaper
import "root:/Modules/Notifications" as Notifications

ShellRoot {
    id: root
    property bool enableBar: true
    property bool enableWallpaper: true
    property bool enableNotifications: true

    LazyLoader {
        active: root.enableBar

        component: Bar.Bar {}
    }

    LazyLoader {
        active: root.enableWallpaper

        component: Wallpaper.WallpaperWindow {}
    }

    LazyLoader {
        active: root.enableNotifications

        component: Notifications.NotificationPanel {}
    }
}
