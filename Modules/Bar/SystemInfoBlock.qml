import QtQuick
import "root:/Globals" as Globals

Rectangle {
    id: root

    property string iconText
    property string mainText
    property int mainTextWidth: 60
    property Component customView: null
    property alias customItem: customViewLoader.item

    radius: Globals.Sizes.borderRadius
    implicitWidth: contentRow.implicitWidth + (contentRow.leftPadding + contentRow.rightPadding)
    implicitHeight: Globals.Sizes.barBlockHeihgt
    color: Globals.Colors.barElementBackgroundColor


    border {
        width: Globals.Sizes.borderWidth
        color: Globals.Colors.barElementBorderColor
    }

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
            color: Globals.Colors.barElementTextColor
        }

        Item {
            width: mainTextWidth
            height: mainText.implicitHeight
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: mainText

                font.family: "SF Pro Display"
                font.weight: Font.Bold
                font.pixelSize: 14
                text: root.mainText
                anchors.left: parent.left
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Globals.Colors.barElementTextColor
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
                    item.height = Qt.binding(function() {
                        return parent.height;
                    });
                    item.width = Qt.binding(function() {
                        return item.implicitWidth;
                    });
                }
            }
        }

    }

}
