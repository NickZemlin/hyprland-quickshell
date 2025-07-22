import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "root:/Globals" as Globals
import "root:/Services" as Services

Rectangle {
    id: root

    width: Globals.Sizes.launcherMaxWidth
    height: Globals.Sizes.launcherMaxHeight
    color: 'transparent'
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
            Services.LauncherService.performSelectedAction();

        if (event.key === Qt.Key_Up)
            Services.LauncherService.moveUp();

        if (event.key === Qt.Key_Down)
            Services.LauncherService.moveDown();

    }

    Column {
        width: Globals.Sizes.launcherMaxWidth
        spacing: 8

        SearchBar {
            anchors.horizontalCenter: parent.horizontalCenter

            border {
                width: Globals.Sizes.borderWidth
                color: Globals.Colors.barElementActiveBorderColor
                pixelAligned: true
            }

        }

        ClippingRectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Globals.Sizes.launcherMaxWidth
            height: Math.min(listView.contentHeight, Globals.Sizes.launcherMaxHeight) // Bind to ListView's content height
            color: Globals.Colors.barElementBackground
            radius: Globals.Sizes.borderRadius
            clip: true

            border {
                width: Globals.Sizes.borderWidth
                color: Globals.Colors.barElementBorderColor
                pixelAligned: true
            }

            ListView {
                id: listView

                highlightMoveDuration: 25
                width: parent.width
                height: Math.min(contentHeight, Globals.Sizes.launcherMaxHeight)
                spacing: 2
                model: Services.LauncherService.list
                currentIndex: Services.LauncherService.selectedIndex

                highlight: Component {
                    Rectangle {
                        color: "transparent"

                        Rectangle {
                            color: "transparent"
                            width: Globals.Sizes.launcherInputHeight
                            height: parent.height

                            Text {
                                text: ">"
                                anchors.centerIn: parent
                                font.pixelSize: 30
                                color: Globals.Colors.barElementTextColor
                                font.weight: Font.Bold
                                font.family: "SF Pro Display"
                            }

                        }

                    }

                }

                delegate: LauncherEntryView {
                    entry: modelData
                    width: Globals.Sizes.launcherMaxWidth
                    isSelectedItem: Services.LauncherService.selectedIndex === index
                }

            }

        }

    }

}
