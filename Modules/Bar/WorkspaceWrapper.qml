import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "root:/Globals" as Globals

Rectangle {
    id: root

    property int workspaceId: 0
    property bool isActive: false
    property int numberOfChildren: 0
    property var biggestWindow: null
    property bool isInitialized: false
    readonly property int minWidth: 28 + row.padding * 2
    property string iconSource: {
        if (!biggestWindow || !biggestWindow["class"])
            return "";

        const cls = biggestWindow["class"];
        const lowerCls = cls.toLowerCase();
        const iconNames = [lowerCls, cls, lowerCls.replace(/ /g, "-"), "application-" + lowerCls].filter((name) => {
            return name && name.length > 0;
        });
        for (var i = 0; i < iconNames.length; i++) {
            const path = Quickshell.iconPath(iconNames[i], true);
            if (path && path !== "")
                return path;

        }
        return "";
    }

    width: Math.max(row.implicitWidth, minWidth)
    height: Globals.Sizes.barBlockHeihgt
    radius: Globals.Sizes.radius
    clip: true
    states: [
        State {
            name: "active"
            when: root.isActive

            PropertyChanges {
                target: root
                color: Globals.Colors.workspaceActive
            }

            PropertyChanges {
                target: fallbackRect
                opacity: 0.9
            }

        },
        State {
            name: "hovered"
            when: !root.isActive && mouseArea.containsMouse

            PropertyChanges {
                target: root
                border.color: Globals.Colors.barElementHoveredBorderColor
                color: Globals.Colors.workspaceInactive
            }

        },
        State {
            name: "initialized"
            when: root.isInitialized && !root.isActive

            PropertyChanges {
                target: root
                color: Globals.Colors.workspaceInactive
            }

            PropertyChanges {
                target: fallbackRect
                opacity: 0.7
            }

            PropertyChanges {
                target: dotsContainer
                opacity: 0
            }

        },
        State {
            name: "empty"
            when: !root.isInitialized && !root.isActive

            PropertyChanges {
                target: root
                color: Globals.Colors.workspaceInactive
            }

            PropertyChanges {
                target: fallbackRect
                opacity: 0.5
            }

        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "*"

            ColorAnimation {
                duration: 150
            }

            NumberAnimation {
                duration: 150
            }

        }
    ]

    border {
        width: Globals.Sizes.borderWidth
        color: {
            if (isActive)
                return Globals.Colors.barElementActiveBorderColor;

            return Globals.Colors.barElementBorderColor;
        }
    }

    Row {
        id: row

        padding: Globals.Sizes.workspacesPadding
        spacing: Globals.Sizes.workspacesPadding
        anchors.centerIn: parent
        height: parent.height - (padding * 2)

        Item {
            id: iconContainer

            anchors.verticalCenter: parent.verticalCenter
            width: 22
            height: 22

            ClippingWrapperRectangle {
                width: iconContainer.width
                height: iconContainer.height
                radius: 8
                color: "transparent"

                Image {
                    id: iconImage

                    anchors.fill: parent
                    source: iconSource
                    sourceSize.width: 22 * 1.3
                    sourceSize.height: 22 * 1.3
                    smooth: true
                    antialiasing: true
                    visible: status === Image.Ready && source !== ""
                    fillMode: Image.PreserveAspectFit
                }

            }

            Rectangle {
                id: fallbackRect

                anchors.margins: Globals.Sizes.borderWidth
                anchors.fill: parent
                radius: 6
                visible: !iconImage.visible
                color: {
                    return Globals.Colors.workspaceFallbackRect;
                }
            }

            Text {
                anchors.centerIn: parent
                text: workspaceId.toString()
                color: Globals.Colors.workspaceFallbackRectText
                font.pixelSize: 10
                font.bold: isActive
                visible: !biggestWindow
                font.family: "FreeMono"
            }

        }

        Repeater {
            id: dotsContainer

            model: numberOfChildren > 1 ? Math.min(numberOfChildren - 1, 5) : 0

            delegate: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: Globals.Sizes.workspacesDotSize
                height: width
                color: isActive ? Globals.Colors.workspaceDotActive : Globals.Colors.workspaceDotInactive
                radius: width / 2
            }

        }

        Text {
            visible: numberOfChildren > 6
            anchors.verticalCenter: parent.verticalCenter
            text: "+" + (numberOfChildren - 6).toString()
            color: Globals.Colors.workspaceNumberOfWindows
            font.pixelSize: 12
        }

    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            switchToWorkspace.running = true;
        }
    }

    Process {
        id: switchToWorkspace

        command: ["hyprctl", "dispatch", "workspace", workspaceId.toString()]
    }

}
