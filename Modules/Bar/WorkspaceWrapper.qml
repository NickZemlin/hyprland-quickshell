import QtQuick
import "root:/Globals" as Globals

Rectangle {
    property int index
    property bool isActive
    property int numberOfChilder
    property string state: "active"

    width: Math.max(row.implicitWidth, minWidth)
    height: row.implicitHeight
    color: "#595959"
    radius: 6
    clip: true  // Prevent children from appearing outside

    // Minimum width to contain the biggestWindow + padding
    readonly property int minWidth: biggestWindow.width + row.padding * 2

    Row {
        id: row
        padding: 5
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: biggestWindow
            radius: 6
            color: "#FF0000"
            width: 18
            height: 18
            
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

    }

    Behavior on width {
        NumberAnimation { duration: 150}
    }
}

// dots to show number of windows
// Repeater {
//     model: numberOfChilder
//     delegate: Rectangle {
//         id: childDot
//         property bool exiting: false
        
//         anchors.verticalCenter: parent.verticalCenter
//         width: exiting ? 0 : (isActive ? 9 : 0)
//         height: width
//         color: "#FF0000"
//         radius: width / 2
//         opacity: exiting ? 0 : (isActive ? 1 : 0)
//         visible: !exiting || opacity > 0

//         Behavior on width { NumberAnimation { duration: 150 } }
//         Behavior on opacity { NumberAnimation { duration: 150 } }

//         Component.onCompleted: {
//             if (index >= numberOfChilder) {
//                 exiting = true;
//                 destroy(150); // Destroy after animation duration
//             }
//         }
//     }
// }