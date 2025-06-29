import QtQuick
import "root:/Globals" as Globals

Rectangle {
    id: root
    
    property string iconText
    property string mainText
    property int mainTextWidth: 60 
    property Component customView: null
    
    radius: 4
    implicitWidth: contentRow.implicitWidth + (contentRow.leftPadding + contentRow.rightPadding)
    implicitHeight: Globals.Sizes.barBlockHeihgt
    color: Globals.Colors.barElementBackground

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: Globals.Sizes.barItemInnerPadding
        height: parent.height
        leftPadding: Globals.Sizes.barItemInnerPadding
        rightPadding: Globals.Sizes.barItemInnerPadding

        Text {
            font.family: "JetBrainsMonoNerdFont"
            font.weight: Font.Bold
            font.pixelSize: 16
            text: root.iconText
            anchors.verticalCenter: parent.verticalCenter
        }

       Item {
            width: mainTextWidth
            height: mainText.implicitHeight 
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id: mainText
                font.family: "FreeMono"
                font.weight: Font.Bold
                font.pixelSize: 14
                text: root.mainText
                anchors.left: parent.left                
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        
        Loader {
            id: customViewLoader
            sourceComponent: root.customView
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: item ? item.implicitWidth : 0
            
            onItemChanged: {
                if (item) {
                    item.height = Qt.binding(function() { return parent.height; });
                    item.width = Qt.binding(function() { return item.implicitWidth; });
                }
            }
        }
    }
    
    property alias customItem: customViewLoader.item
}