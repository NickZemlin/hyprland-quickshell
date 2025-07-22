import QtQuick
import Quickshell
import Quickshell.Widgets
import "root:/Globals" as Globals
import "root:/Services" as Services

Rectangle {
    id: root

    property QtObject entry
    property bool isSelectedItem
    property string iconSource: {
        const path = Quickshell.iconPath(Services.AppSearch.guessIcon(entry.iconString), true);
        if (path && path !== "")
            return path;

        return "";
    }

    height: Globals.Sizes.launcherInputHeight
    color: isSelectedItem ? "transparent" : "transparent"

    Row {
        id: rootRow

        height: parent.height 
        width: parent.width
        spacing: 8
        padding: 8 // TODO: disconnect horizontal and vertical
        leftPadding: padding + (isSelectedItem ? Globals.Sizes.launcherInputHeight : 0) // adds 8 extra pixels when selected

        Item {
            id: iconContainer

            anchors.verticalCenter: parent.verticalCenter
            width: 32
            height: 32

            ClippingWrapperRectangle {
                width: iconContainer.width
                height: iconContainer.height
                radius: 8
                color: "transparent"

                Image {
                    id: iconImage

                    anchors.fill: parent
                    source: iconSource
                    sourceSize.width: 32 * 1.3
                    sourceSize.height: 32 * 1.3
                    smooth: true
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
                text: entry.title.toString()
                color: Globals.Colors.workspaceFallbackRectText
                font.pixelSize: 10
                visible: !entry.iconString
                font.family: "SF Pro Display"
            }

        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: entry.title
                color: Globals.Colors.barElementTextColor
                width: parent.width
                font.weight: Font.Bold
                maximumLineCount: 1
                elide: Text.ElideRight
                font.family: "SF Pro Display"
                font.pixelSize: 18
            }

            Text {
                text: entry.subTitle
                color: Globals.Colors.barElementTextColor
                maximumLineCount: 1
                elide: Text.ElideRight
                font.family: "SF Pro Display"
                font.pixelSize: 14
                width: root.width - iconContainer.width - rootRow.padding - 10
            }

        }

        Behavior on leftPadding {
            NumberAnimation {
                duration: 25 // Animation duration in milliseconds
                easing.type: Easing.OutQuad // Smooth easing curve
            }

        }

    }

}
