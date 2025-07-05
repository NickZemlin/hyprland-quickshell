import QtQuick
import Quickshell

import "root:/Globals" as Globals
import "root:/Services" as Services

Scope {
    id: bar

    PanelWindow {
        color: 'transparent'
        implicitHeight: Globals.Sizes.barHeight
        anchors {
            top: true 
            left: true
            right: true
        }

        margins {
            top: {
                let gapsIs = Services.HyprlandData.config.general?.gaps_in
                if (gapsIs) {
                    return gapsIs.split(",")[0]
                }
                return 5
            }
        }

        Workspaces {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }

        Row {
            spacing: {
                let gapsIs = Services.HyprlandData.config.general?.gaps_in
                if (gapsIs) {
                    return gapsIs.split(",")[0]
                }
                return 5
            }

            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: {
                    let gapsOut = Services.HyprlandData.config.general?.gaps_out
                    if (gapsOut){
                        let toSplit = gapsOut.split(',')
                        if ([2,3,4].includes(toSplit.length)){
                            return toSplit[1]
                        }
                        return toSplit[0]
                    }
                    return 20
                }

            }

            SystemInfo {}

            BarDate {}
        }
    }
}
