import QtQuick
import Quickshell
import "root:/Globals" as Globals
import "root:/Services" as Services

Scope {
    id: panel

    readonly property int notificationOffset: 10 

    PanelWindow {
        color: 'transparent'
        implicitWidth: Globals.Sizes.notificationsPanelWidth
        exclusionMode: ExclusionMode.Ignore
        mask: Region { item: listView }
        
        anchors {
            top: true
            bottom: true
            right: true
        }

        margins {
            top: Globals.Sizes.gapsOutVertical + Globals.Sizes.barBlockHeihgt + notificationOffset
        }

        ListView {
            id: listView
            interactive: false
            width: parent.width
            height: contentHeight
            spacing: Globals.Sizes.gapsIn + Globals.Sizes.borderWidth
            
            model: Services.NotificationsService.list
            
            delegate: NotificationElement {
                notif: modelData
            }
            
            add: Transition {
                ParallelAnimation {
                    NumberAnimation { 
                        property: "opacity"
                        from: 0
                        to: 1.0
                        duration: Globals.AnimationSpeeds.mediumAnimation
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation { 
                        property: "x"
                        from: listView.width
                        to: 0
                        duration: Globals.AnimationSpeeds.mediumAnimation
                        easing.type: Easing.OutCubic
                    }
                }
            }
            
            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { 
                        property: "opacity"
                        to: 0
                        duration: Globals.AnimationSpeeds.mediumAnimation
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation { 
                        property: "x"
                        to: listView.width
                        duration: Globals.AnimationSpeeds.mediumAnimation
                        easing.type: Easing.InCubic
                    }
                }
            }
            
            displaced: Transition {
                NumberAnimation { 
                    property: "y"
                    duration: Globals.AnimationSpeeds.mediumAnimation
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
}