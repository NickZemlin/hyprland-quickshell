import Quickshell
import QtQuick

import "root:/Modules/Bar" as Bar
import "root:/Modules/Wallpaper" as Wallpaper
import "root:/Modules/Notifications" as Notifications
import "root:/Modules/Launcher" as Launcher

ShellRoot {
    id: root
    property bool enableBar: true
    property bool enableWallpaper: true
    property bool enableNotifications: true
    property bool enableLauncher: true

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

    LazyLoader {
        active: root.enableLauncher

        component: Launcher.LauncherWindow{ }
    }
}
