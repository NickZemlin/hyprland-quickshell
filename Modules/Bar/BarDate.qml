import QtQuick
import Quickshell
import Quickshell.Io
import "root:/Globals" as Globals

Rectangle {
    id: rect

    color: Globals.Colors.barElementBackgroundColor
    radius: Globals.Sizes.borderRadius
    implicitWidth: row.implicitWidth + row.padding * 2
    implicitHeight: Globals.Sizes.barBlockHeihgt
    states: [
        State {
            name: "hovered"
            when: hoverHandler.hovered

            PropertyChanges {
                target: rect
                border.color: Globals.Colors.barElementHoveredBorderColor
            }
        },
        State {
            name: "default"
            when: !hoverHandler.hovered

            PropertyChanges {
                target: rect
            }
        }
    ]
    transitions: [
        Transition {
            from: "default"
            to: "hovered"

            ColorAnimation {
                duration: Globals.AnimationSpeeds.mediumAnimation
                easing.type: Easing.InOutQuad
            }

        },
        Transition {
            from: "hovered"
            to: "default"

            ColorAnimation {
                duration: Globals.AnimationSpeeds.mediumAnimation
                easing.type: Easing.InOutQuad
            }

        }
    ]

    border {
        width: Globals.Sizes.borderWidth
        color: Globals.Colors.barElementBorderColor
    }

    Row {
        id: row

        anchors.centerIn: parent
        spacing: Globals.Sizes.barItemInnerPadding
        padding: Globals.Sizes.barItemInnerPadding

        Text {
            font.family: "SF Pro Display"
            font.weight: Font.Bold
            font.pixelSize: 14
            text: Qt.formatDateTime(clock.date, "hh:mm")
            color: Globals.Colors.barElementTextColor
        }

        Text {
            font.family: "SF Pro Display"
            font.weight: Font.Bold
            font.pixelSize: 14
            text: "|"
            color: Globals.Colors.barElementTextColor
        }

        Text {
            font.family: "SF Pro Display"
            font.weight: Font.Bold
            font.pixelSize: 14
            text: Qt.formatDateTime(clock.date, "dd MMM")
            color: Globals.Colors.barElementTextColor
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
