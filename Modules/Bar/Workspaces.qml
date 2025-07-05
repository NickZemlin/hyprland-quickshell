import QtQuick
import Quickshell.Hyprland
import "root:/Globals" as Globals
import "root:/Services" as Services

Row {
    property int activeIndex: 0

    spacing: 3

Rectangle {
    width: row.childrenRect.width
    height: Globals.Sizes.barBlockHeihgt
    radius: Globals.Sizes.barBlockHeihgt / 2

    Row {
        id: row
        spacing: 12
        anchors.centerIn: parent
        Repeater {
            model: 10
            WorkspaceWrapper {
                index: model.index
                isActive: model.index === activeIndex
                numberOfChilder: 5
            }
        }
    }
}
    Connections {
        function onRawEvent(event) {
            Hyprland.workspaces.values.forEach((el) => {
                if (el.active)
                    activeIndex = el.id - 1;

            });
        }

        target: Hyprland
    }

}
