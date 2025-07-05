
import QtQuick
import Quickshell
import Quickshell.Io
import "root:/Globals" as Globals

Rectangle {
    property int workspaceId: 0
    property bool isActive: false
    property int numberOfChildren: 0
    property var biggestWindow: null
    property bool isInitialized: false

    width: Math.max(row.implicitWidth, minWidth)
    height: 28  // Fixed height
    color: {
        if (isActive) return "#696969"
        else if (isInitialized) return "#595959"
        else return "#3a3a3a"
    }
    radius: 6
    clip: true
    border.width: isActive ? 1 : 0
    border.color: "#999999"
    opacity: isInitialized || isActive ? 1.0 : 0.6

    // Minimum width to contain the content + padding
    readonly property int minWidth: 28 + row.padding * 2

    // Use Quickshell.iconPath for better icon resolution
    property string iconSource: {
        if (!biggestWindow || !biggestWindow["class"]) return ""
        
        const cls = biggestWindow["class"];
        const lowerCls = cls.toLowerCase();
        
        // Try multiple icon name patterns
        const iconNames = [
            lowerCls,
            cls,
            lowerCls.replace(/ /g, "-"),
            "application-" + lowerCls,
            biggestWindow.initialClass ? biggestWindow.initialClass.toLowerCase() : "",
            // Add more specific mappings for known problematic apps
            lowerCls === "code-oss" ? "visual-studio-code" : "",
            lowerCls === "code-oss" ? "vscode" : "",
            lowerCls === "dota2" ? "steam_icon_570" : "",
            lowerCls === "dota2" ? "dota2" : ""
        ].filter(name => name && name.length > 0);
        
        // Try each icon name with Quickshell.iconPath
        for (var i = 0; i < iconNames.length; i++) {
            const path = Quickshell.iconPath(iconNames[i], "");
            if (path && path !== "") {
                return path;
            }
        }
        
        return "";
    }

    Row {
        id: row
        padding: 5
        spacing: 4
        anchors.centerIn: parent
        height: parent.height - (padding * 2)

        Item {
            id: iconContainer
            anchors.verticalCenter: parent.verticalCenter
            width: 18
            height: 18

            // Try to load icon using resolved path
            Image {
                id: iconImage
                anchors.fill: parent
                source: iconSource
                sourceSize.width: 32
                sourceSize.height: 32
                smooth: true
                antialiasing: true
                visible: status === Image.Ready && source !== ""
                fillMode: Image.PreserveAspectFit
            }


// Fallback colored rectangle
            Rectangle {
                id: fallbackRect
                anchors.fill: parent
                radius: 6
                visible: !iconImage.visible
                color: {
                    if (!biggestWindow && !isInitialized) return "#2a2a2a"
                    if (!biggestWindow) return "#393939"
                    
                    // Generate color from class name
                    if (biggestWindow && biggestWindow["class"]) {
                        const className = biggestWindow["class"];
                        var hash = 0;
                        for (var i = 0; i < className.length; i++) {
                            hash = ((hash << 5) - hash) + className.charCodeAt(i);
                        }
                        const hue = Math.abs(hash) % 360;
                        return Qt.hsla(hue / 360, 0.6, 0.5, 1.0);
                    }
                    return "#FF0000"
                }
                
                // Show first letter of app class as fallback
                Text {
                    anchors.centerIn: parent
                    text: biggestWindow ? biggestWindow["class"].charAt(0).toUpperCase() : ""
                    color: "#FFFFFF"
                    font.pixelSize: 12
                    font.bold: true
                    visible: biggestWindow !== null
                }
            }

            // Show workspace number when empty
            Text {
                anchors.centerIn: parent
                text: workspaceId.toString()
                color: isInitialized ? "#FFFFFF" : "#666666"
                font.pixelSize: 10
                font.bold: isActive
                visible: !biggestWindow
            }
        }

        // Dots to show additional windows
        Repeater {
            model: numberOfChildren > 1 ? Math.min(numberOfChildren - 1, 5) : 0
            delegate: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 6
                height: width
                color: isActive ? "#FFFFFF" : "#AAAAAA"
                radius: width / 2
                opacity: isActive ? 0.9 : 0.6

                Behavior on width { NumberAnimation { duration: 150 } }
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }
        }
        
        // Show "+n" if there are too many windows
        Text {
            visible: numberOfChildren > 6
            anchors.verticalCenter: parent.verticalCenter
            text: "+" + (numberOfChildren - 6).toString()
            color: "#AAAAAA"
            font.pixelSize: 9
        }
    }


Behavior on width {
        NumberAnimation { duration: 150 }
    }
    
    Behavior on color {
        ColorAnimation { duration: 150 }
    }
    
    Behavior on opacity {
        NumberAnimation { duration: 150 }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            switchToWorkspace.running = true;
        }
    }
    
    Process {
        id: switchToWorkspace
        command: ["hyprctl", "dispatch", "workspace", workspaceId.toString()]
    }
    
    // Tooltip
    Rectangle {
        visible: mouseArea.containsMouse && (biggestWindow !== null || !isInitialized)
        anchors.bottom: parent.top
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        
        width: tooltipText.width + 16
        height: tooltipText.height + 8
        radius: 4
        color: "#2a2a2a"
        border.width: 1
        border.color: "#444444"
        
        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: {
                if (!isInitialized) return "Workspace " + workspaceId + " (uninitialized)"
                if (!biggestWindow) return "Workspace " + workspaceId + " (empty)"
                var title = biggestWindow.title;
                var className = biggestWindow["class"];
                if (title.length > 50) {
                    return className + ": " + title.substring(0, 50) + "..."
                } else {
                    return className + ": " + title
                }
            }
            color: "#FFFFFF"
            font.pixelSize: 11
        }
    }
}