import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "root:/Globals" as Globals
import "root:/Services" as Services

Rectangle {
    id: root

    property alias searchBar: internalSearchBar
    property alias contentView: internalContentView

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
        if (event.key === Qt.Key_Escape){
            Services.LauncherService.laucherPresented = false
        }
    }

    Column {
        width: Globals.Sizes.launcherMaxWidth
        spacing: 8

        SearchBar {
            id: internalSearchBar
            anchors.horizontalCenter: parent.horizontalCenter

            border {
                width: Globals.Sizes.borderWidth
                color: Globals.Colors.barElementActiveBorderColor
                pixelAligned: true
            }

        }

        ClippingRectangle {
            id: internalContentView
            anchors.horizontalCenter: parent.horizontalCenter
            width: Globals.Sizes.launcherMaxWidth
            height: Globals.Sizes.launcherMaxHeight
            color: Globals.Colors.barElementBackground
            radius: Globals.Sizes.borderRadius
            clip: true
            visible: Services.LauncherService.inputText

            border {
                width: Globals.Sizes.borderWidth
                color: Globals.Colors.barElementBorderColor
                pixelAligned: true
            }

            ListView {
                id: listView
                width: parent.width
                height: Globals.Sizes.launcherMaxHeight
                spacing: 0
                topMargin: 8
                model: Services.LauncherService.list
                currentIndex: Services.LauncherService.selectedIndex


                delegate: LauncherEntryView {
                    entry: modelData
                    width: Globals.Sizes.launcherMaxWidth
                    isSelectedItem: Services.LauncherService.selectedIndex === index
                }

            }

        }

    }

}
