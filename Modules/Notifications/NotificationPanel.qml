import QtQuick
import Quickshell
import "root:/Globals" as Globals
import "root:/Services" as Services

Scope {
    id: panel

    PanelWindow {
        color: 'transparent'
        implicitWidth: Globals.Sizes.notificationsPanelWidth
        exclusionMode: ExclusionMode.Ignore
        mask: Region { item: column }
        

        anchors {
            top: true
            bottom: true
            right: true
        }

        margins {
            top: Globals.Sizes.gapsOutVertical + Globals.Sizes.barBlockHeihgt + 10
            right: Globals.Sizes.gapsOutHorizontal + 10
        }

        Column {
            id: column
            spacing: Globals.Sizes.gapsIn + Globals.Sizes.borderWidth
            Repeater {
                model: Services.NotificationsService.list
                NotificationElement{
                    notif: model
                }
            }

        }

    }

}
