// root:/Services/WallpaperService.qml
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "root:/Assets/Wallpapers" as Wallpapers

Singleton {
    id: root

    // Current wallpaper and theme properties
    property var currentWallpaper: Wallpapers.RegistredWallpapers.papers[0]
    property var hyprlandColors: ({
        active: currentWallpaper?.activeBorderColor ?? "",
        inactive: currentWallpaper?.inactiveBorderColor ?? ""
    })

    // Process for applying Hyprland settings
    Process {
        id: hyprlandProcess
    }

    // Connection to update Hyprland configuration after commands are executed
    Connections {
        target: hyprlandProcess

        function onExited() {
            if (typeof HyprlandData !== 'undefined' && HyprlandData.updateConfig) {
                HyprlandData.updateConfig();
            }
        }
    }

    // Function to set wallpaper by name
    function setWallpaperByName(name) {
        for (let i = 0; i < Wallpapers.RegistredWallpapers.papers.length; i++) {
            if (Wallpapers.RegistredWallpapers.papers[i].name === name) {
                currentWallpaper = Wallpapers.RegistredWallpapers.papers[i];
                updateHyprlandColors();
                return true;
            }
        }
        return false;
    }

    // Update Hyprland with current wallpaper's colors
    function updateHyprlandColors() {
        if (!currentWallpaper?.activeBorderColor || !currentWallpaper?.inactiveBorderColor){
            hyprlandProcess.command = [
                "hyprctl", 
                "reload"
            ];
        } else {
            hyprlandColors = {
                active: currentWallpaper.activeBorderColor,
                inactive: currentWallpaper.inactiveBorderColor
            };
            
            hyprlandProcess.command = [
                "hyprctl", 
                "--batch", 
                `keyword general:col.active_border ${hyprlandColors.active} ; keyword general:col.inactive_border ${hyprlandColors.inactive}`
            ];
        }
        hyprlandProcess.running = true;
    }

    // Initialize with default wallpaper colors
    Component.onCompleted: {
        updateHyprlandColors();
    }
}