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

    height: 40
    color: "transparent"

    Rectangle {
        color: isSelectedItem ? Globals.Colors.barElementHoveredBorderColor : "transparent"
        radius: 7
        height: parent.height
        anchors {

            fill: parent
            leftMargin: 8
            rightMargin: 8
        }

        Row {
            id: rootRow

            height: parent.height
            width: parent.width
            spacing: 8
            padding: 8 // TODO: disconnect horizontal and vertical
            leftPadding: 8 // adds 8 extra pixels when selected

            Item {
                id: iconContainer

                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20

                ClippingWrapperRectangle {
                    width: iconContainer.width
                    height: iconContainer.height
                    radius: 8
                    color: "transparent"

                    Image {
                        id: iconImage

                        anchors.fill: parent
                        source: iconSource
                        sourceSize.width: 20 * 1.3
                        sourceSize.height: 20 * 1.3
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

            }


                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: entry.title
                    color: Globals.Colors.barElementTextColor
                    width: parent.width
                    font.weight: Font.Bold
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    font.family: "SF Pro Display"
                    font.pixelSize: 14
                }

        }

    }

}
