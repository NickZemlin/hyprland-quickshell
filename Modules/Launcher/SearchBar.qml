import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "root:/Globals" as Globals
import "root:/Services" as Services

Rectangle {
    id: searchBar

    width: parent.width + Globals.Sizes.borderWidth
    height: Globals.Sizes.launcherInputHeight
    anchors.horizontalCenter: parent.horizontalCenter
    color: Globals.Colors.barElementHovered
    radius: Globals.Sizes.borderRadius

    Row {
        anchors.fill: parent
        leftPadding: Globals.Sizes.launcherInputIconSquare / 2
        spacing: Globals.Sizes.launcherInputIconSquare / 4

        Item {
            anchors.verticalCenter: parent.verticalCenter
            height: Globals.Sizes.launcherInputIconSquare
            width: Globals.Sizes.launcherInputIconSquare

            Rectangle {
                anchors.fill: parent
                color: "transparent"
            }

            Text {
                text: ">"
                anchors.centerIn: parent
                font.pixelSize: 30
                color: Globals.Colors.barElementTextColor
                font.weight: Font.Bold
                font.family: "SF Pro Display"
            }

        }

        TextInput {
            id: input

            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            leftPadding: 10
            rightPadding: 10
            focus: true
            color: Globals.Colors.barElementTextColor
            selectionColor: Globals.Colors.workspaceFallbackRectText
            autoScroll: true
            font.family: "SF Pro Display"
            font.pixelSize: 20
            text: Services.LauncherService.inputText
            onTextChanged: Services.LauncherService.inputText = text
        }

    }

}
