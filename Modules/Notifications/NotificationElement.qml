import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "root:/Globals" as Globals
import "root:/Services" as Services

Rectangle {
    id: rect

    property QtObject notif
    property bool notificationNull: {
        if (notif.notification === null) {
            Services.NotificationsService.discardNotification(notif.notificationId);
            return true;
        }
        return false;
    }
    property string iconSource: {
        const path = Quickshell.iconPath(Services.AppSearch.guessIcon(notif.appIcon), true);
        if (path && path !== "")
            return path;

        return "";
    }
    property string notificationBody: {
        return notif.body;
    }

    implicitWidth: Globals.Sizes.notificationsPanelWidth
    radius: Globals.Sizes.borderRadius
    height: column.implicitHeight + 16
    color: Qt.rgba(Globals.Colors.barElementBackgroundColor.r, Globals.Colors.barElementBackgroundColor.g, Globals.Colors.barElementBackgroundColor.b, 0.8)
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
                border.color: Globals.Colors.barElementBorderColor
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

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton // Only handle right-clicks
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                console.log("Right-clicked notification:", notif.appName + " " + notif.notificationId);
                Services.NotificationsService.discardNotification(notif.notificationId);
            }
        }
    }

    HoverHandler {
        id: hoverHandler

        cursorShape: Qt.PointingHandCursor
    }

    border {
        color: Globals.Colors.barElementActiveBorderColor
        width: Globals.Sizes.borderWidth
    }

    Column {
        id: column

        spacing: 8
        width: parent.width - 16

        anchors {
            top: parent.top
            left: parent.left
            margins: 8
        }

        Row {
            spacing: 8
            height: 22

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
                    text: notif.appName.toString()
                    color: Globals.Colors.workspaceFallbackRectText
                    font.pixelSize: 10
                    visible: !notif.appIcon
                    font.family: "FreeMono"
                }

            }

            Text {
                text: notif.appName
                anchors.verticalCenter: parent.verticalCenter
                color: Globals.Colors.barElementTextColor
                font.weight: Font.Bold
            }

        }

        Row {
            width: parent.width
            spacing: 8

            Item {
                id: imageContainer

                width: 22
                height: 22

                ClippingWrapperRectangle {
                    width: imageContainer.width
                    height: imageContainer.height
                    radius: 22
                    color: "transparent"

                    Image {
                        id: image

                        anchors.fill: parent
                        source: notif.image
                        sourceSize.width: 22 * 1.5
                        sourceSize.height: 22 * 1.5
                        smooth: true
                        antialiasing: true
                        visible: status === Image.Ready && source !== ""
                        fillMode: Image.PreserveAspectFit
                    }

                }

            }

            Column {
                width: parent.width
                spacing: 4
                Text {
                    text: notif.summary + ":"
                    color: Globals.Colors.barElementTextColor
                    width: parent.width
                    font.weight: Font.Bold
                    maximumLineCount: 1
                    elide: Text.ElideRight
                }

                Text {
                    text: notificationBody
                    color: Globals.Colors.barElementTextColor
                    width: parent.width
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                }

            }

        }

    }

}
