import QtQuick
import Quickshell
import "root:/Globals" as Globals
import "root:/Services" as Services

Scope {
    id: wallpaperWindow

    property int paralaxOffset: 5
    property int animationDuration: Globals.AnimationSpeeds.mediumAnimation

    PanelWindow {
        exclusionMode: ExclusionMode.Ignore
        aboveWindows: false
        color: 'transparent'

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        Rectangle {
            id: wallpaperWrapper
            visible: !!Services.WallpaperService.currentWallpaper?.path
            color: 'transparent'
            x: -paralaxOffset
            height: parent.height
            width: parent.width + paralaxOffset

            Image {
                source: Services.WallpaperService.currentWallpaper?.path ?? ""
                fillMode: Image.PreserveAspectCrop
                anchors.verticalCenter: parent.verticalCenter
                x: -paralaxOffset * Services.HyprlandData.activeWorkspace.id
                height: parent.height
                width: parent.width + paralaxOffset * 10
                Behavior on x {
                    NumberAnimation {
                        duration: animationDuration
                        easing.type: Easing.InOutQuad
                    }

                }

            }

        }

    }

}
