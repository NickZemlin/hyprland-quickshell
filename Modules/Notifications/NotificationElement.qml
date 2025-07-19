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
        if (notif.notification === null) { // TODO: fix Binding loop but keep animations
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
    property real progress: calculateProgress()
    property int lifetime: 5000 // 10 seconds

    function calculateProgress() {
        if (notificationNull)
            return 1;

        const elapsed = new Date().getTime() - notif.time;
        return Math.min(elapsed / lifetime, 1);
    }

    implicitWidth: Globals.Sizes.notificationElementWidth
    radius: Globals.Sizes.borderRadius
    height: column.implicitHeight + Globals.Sizes.notifProgressMargin + progressBar.height
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

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton)
                Services.NotificationsService.discardNotification(notif.notificationId);

            if (mouse.button === Qt.LeftButton) {
                let command = [];
                if (notif.notification.hints["sender-pid"])
                    command = ["hyprctl", "dispatch", "focuswindow", `pid:${notif.notification.hints["sender-pid"]}`];
                else
                    command = ["hyprctl", "dispatch", "focuswindow", `class:${notif.notification.desktopEntry.toLowerCase()}`];
                focusProcess.command = command;
                focusProcess.running = true;
            }
        }
    }

    Process {
        id: focusProcess

        running: false
        onExited: (statusCode, status) => {
            if (notif.notification.actions) {
                let defaultAction = notif.notification.actions.filter((el) => {
                    return el.identifier === 'default';
                })[0];
                if (defaultAction)
                    defaultAction.invoke();

            }
        }
    }

    Timer {
        interval: 100
        running: !notificationNull && progress < 1
        repeat: true
        onTriggered: {
            progress = calculateProgress();
            if (progress >= 1 && notif)
                Services.NotificationsService.discardNotification(notif.notificationId);

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

        spacing: Globals.Sizes.notifProgressMarginBottom
        width: parent.width - Globals.Sizes.notifProgressMargin

        anchors {
            top: parent.top
            left: parent.left
            margins: Globals.Sizes.notifProgressMarginBottom
        }

        Row {
            spacing: Globals.Sizes.notifProgressMarginBottom
            height: Globals.Sizes.notifIconSquare

            Item {
                id: iconContainer

                anchors.verticalCenter: parent.verticalCenter
                width: Globals.Sizes.notifIconSquare
                height: Globals.Sizes.notifIconSquare

                ClippingWrapperRectangle {
                    width: iconContainer.width
                    height: iconContainer.height
                    radius: 8
                    color: "transparent"

                    Image {
                        id: iconImage

                        anchors.fill: parent
                        source: iconSource
                        sourceSize.width: Globals.Sizes.notifIconSquare * 1.3
                        sourceSize.height: Globals.Sizes.notifIconSquare * 1.3
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
                    color: Globals.Colors.workspaceFallbackRect
                }

                Text {
                    anchors.centerIn: parent
                    text: notif.appName.toString()
                    color: Globals.Colors.workspaceFallbackRectText
                    font.pixelSize: 10
                    visible: !notif.appIcon
                    font.family: "SF Pro Display"
                }

            }

            Text {
                text: notif.appName
                anchors.verticalCenter: parent.verticalCenter
                color: Globals.Colors.barElementTextColor
                font.weight: Font.Bold
                font.family: "SF Pro Display"
            }

        }

        Row {
            width: parent.width
            spacing: Globals.Sizes.notifProgressMarginBottom

            Item {
                id: imageContainer

                width: Globals.Sizes.notifIconSquare
                height: Globals.Sizes.notifIconSquare

                ClippingWrapperRectangle {
                    width: imageContainer.width
                    height: imageContainer.height
                    radius: Globals.Sizes.notifIconSquare
                    color: "transparent"

                    Image {
                        id: image

                        anchors.fill: parent
                        source: notif.image
                        sourceSize.width: Globals.Sizes.notifIconSquare * 1.5
                        sourceSize.height: Globals.Sizes.notifIconSquare * 1.5
                        smooth: true
                        antialiasing: true
                        visible: status === Image.Ready && source !== ""
                        fillMode: Image.PreserveAspectFit
                    }

                }

            }

            Column {
                width: parent.width - imageContainer.width - parent.spacing
                spacing: 4

                Text {
                    text: notif.summary
                    color: Globals.Colors.barElementTextColor
                    width: parent.width
                    font.weight: Font.Bold
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    font.family: "SF Pro Display"
                }

                Text {
                    text: notificationBody
                    color: Globals.Colors.barElementTextColor
                    width: parent.width
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    font.family: "SF Pro Display"
                }

            }

        }

    }

    Rectangle {
        id: progressBar

        width: parent.width
        height: Globals.Sizes.notifProgressMarginBottom
        color: "transparent"

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            bottomMargin: Globals.Sizes.notifProgressMarginBottom
            leftMargin: Globals.Sizes.notifProgressMargin
            rightMargin: Globals.Sizes.notifProgressMargin
        }

        Rectangle {
            width: parent.width * (1 - progress)
            height: Globals.Sizes.notifProgressHeight
            radius: 4
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: Globals.Colors.barElementActiveBorderColor

            Behavior on width {
                NumberAnimation {
                    duration: Globals.AnimationSpeeds.fastAnimation
                    easing.type: Easing.Linear
                }

            }

        }

    }

}
