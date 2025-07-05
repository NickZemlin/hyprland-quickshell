pragma Singleton
import QtQuick
import Quickshell
import "root:/Services" as Services

Singleton {
    readonly property int barHeight: 32
    readonly property int barBlockHeihgt: barHeight - 2
    readonly property int barItemInnerPadding: 4

    readonly property int borderWidth: {
        let borderSize = Services.HyprlandData.config.general?.border_size
        if (borderSize) {
            return borderSize
        }
        return 2
    }

    readonly property int radius: {
        let rounding = Services.HyprlandData.config.decoration?.rounding
        if (rounding) {
            return rounding
        }
        return 10
    }

    // workspaces
    readonly property int workspacesPadding: 6
    readonly property int workspacesDotSize: 6
}