import QtQuick
import Quickshell

import "root:/Globals" as Globals

Scope {
    id: bar

    property int barHeight: Globals.Sizes.barHeight

    PanelWindow {
        implicitHeight: bar.barHeight

        anchors {
            top: true
            left: true
            right: true
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
                rightMargin: 10
            }

            SystemInfo {
            }

            BarDate {
            }

        }

    }

}
