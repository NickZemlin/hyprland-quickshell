import QtQuick
import Quickshell

import "root:/Globals" as Globals

Scope {
    id: bar

    PanelWindow {
        color: 'transparent'
        implicitHeight: Globals.Sizes.barHeight
        anchors {
            top: true 
            left: true
            right: true
        }

        margins {
            top: 5 // TODO: read hyperland config gaps_out and divide by 2 ?
        }

        Workspaces {
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
        }

        Row {
            spacing: 8

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 20 // TODO: read hyprland config
            }

            SystemInfo {}

            BarDate {}
        }
    }
}
