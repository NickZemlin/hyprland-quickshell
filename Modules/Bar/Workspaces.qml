import QtQuick
import Quickshell.Hyprland
import Quickshell
import Quickshell.Io
import "root:/Services" as Services

Row {
    property int activeIndex: 0
    height: 26
    spacing: 3

    Repeater {
        model: 10

        // Fixed-size container to prevent layout shifts
        Item {
            width: 26  // Enough space for the hovered size (26x26)
            height: 26

            // Actual rectangle (centered in the Item)
            Rectangle {
                id: rect
                width: 20
                height: 20
                anchors.centerIn: parent
                color: activeIndex === index ? "red" : hovered ? "blue" : "green"
                radius: 5
                z: hovered ? 1 : 0  // Bring hovered rect to front

                property bool hovered: false  // Track hover state

                Text {
                    text: index + 1
                    anchors.centerIn: parent
                }

                // Hover effect
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                    onHoveredChanged: {
                        rect.hovered = hovered;
                        rect.width = hovered ? 26 : 20;
                        rect.height = hovered ? 26 : 20;
                    }
                }

                // Click to switch workspace
                TapHandler {
                    onTapped: Hyprland.dispatch(`workspace ${index + 1}`)
                }

                // Smooth animations
                Behavior on width { NumberAnimation { duration: 100 } }
                Behavior on height { NumberAnimation { duration: 100 } }
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }
    }

    Connections {
        function onRawEvent(event) {
            Hyprland.workspaces.values.forEach((el) => {
                if (el.active) activeIndex = el.id - 1;
            });
            console.log(JSON.stringify(Services.HyperlandData.windowList))
        }
        target: Hyprland
    }
    
}