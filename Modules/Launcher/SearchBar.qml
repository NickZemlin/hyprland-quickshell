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

    TextInput {
        id: input

        anchors.fill: parent
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
