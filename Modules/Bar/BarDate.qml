import QtQuick
import Quickshell
import Quickshell.Io

import "root:/Globals" as Globals 

Rectangle {
    id: rect

    radius: 4
    implicitWidth: row.implicitWidth + row.padding * 2
    implicitHeight: Globals.Sizes.barBlockHeihgt
    states: [
        State {
            name: "hovered"
            when: hoverHandler.hovered

            PropertyChanges {
                target: rect
                color: Globals.Colors.barElementHovered
            }

        },
        State {
            name: "default"
            when: !hoverHandler.hovered

            PropertyChanges {
                target: rect
                color: Globals.Colors.barElementBackground
            }

        }
    ]
    transitions: [
        Transition {
            from: "default"
            to: "hovered"

            ColorAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }

        },
        Transition {
            from: "hovered"
            to: "default"

            ColorAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }

        }
    ]

    Row {
        id: row

        anchors.centerIn: parent
        spacing: Globals.Sizes.barItemInnerPadding
        padding: Globals.Sizes.barItemInnerPadding

        Text {
            font.family: "FreeMono"
            font.weight: Font.Bold
            font.pixelSize: 14
            text: Qt.formatDateTime(clock.date, "hh:mm")
        }

        Text {
            font.family: "FreeMono"
            font.weight: Font.Bold
            font.pixelSize: 14
            text: "|"
        }

        Text {
            font.family: "FreeMono"
            font.weight: Font.Bold
            font.pixelSize: 14
            text: Qt.formatDateTime(clock.date, "dd MMM")
        }

        HoverHandler {
            id: hoverHandler

            cursorShape: Qt.PointingHandCursor
        }

        SystemClock {
            id: clock

            precision: SystemClock.Seconds
        }

    }

}
