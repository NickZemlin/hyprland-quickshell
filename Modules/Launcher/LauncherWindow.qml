import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "root:/Globals" as Globals
import "root:/Services" as Services

Scope {
    id: launcherScope

    property int paralaxOffset: 5
    property int animationDuration: Globals.AnimationSpeeds.mediumAnimation

    PanelWindow {
        id: launcherWindow

        color: 'transparent'
        focusable: Services.LauncherService.laucherPresented
        aboveWindows: Services.LauncherService.laucherPresented
        exclusionMode: ExclusionMode.Ignore

        anchors {
            left: true
            bottom: true
            right: true
            top: true
        }

        HyprlandFocusGrab {
            id: grab

            active: Services.LauncherService.laucherPresented
            windows: [launcherWindow]
            onCleared: {
                Services.LauncherService.laucherPresented = false;
            }
        }

        Launcher {
            id: launcher
            visible: Services.LauncherService.laucherPresented

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.verticalCenter
                topMargin: -Globals.Sizes.launcherInputHeight
            }

        }

        mask: Region {
            item: launcher
        }

    }

}
