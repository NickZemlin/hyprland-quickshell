import QtQuick
import Quickshell

import "root:/Globals" as Globals
import "root:/Services" as Services

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
            top: Globals.Sizes.gapsIn
        }

        Workspaces {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }

        Row {
            spacing: Globals.Sizes.gapsIn

            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: Globals.Sizes.gapsOut

            }

            SystemInfo {}

            BarDate {}
        }
    }
}
