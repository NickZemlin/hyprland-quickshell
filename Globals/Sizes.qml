pragma Singleton
import Quickshell
import "root:/Services" as Services

Singleton {
    readonly property int barHeight: 32
    readonly property int barBlockHeihgt: barHeight
    readonly property int barItemInnerPadding: 4

    readonly property int borderWidth: Services.HyprlandData.config.borderSize ?? 2
    readonly property int borderRadius: Services.HyprlandData.config.borderRadius ?? 10
    readonly property int gapsIn: Services.HyprlandData.config.gapsIn?.[0] ?? 5

    readonly property int gapsOutVertical: {
        return Services.HyprlandData.config.gapsOut?.[0] ?? 20
    }

    readonly property int gapsOutHorizontal : {
        if (Services.HyprlandData.config.gapsOut?.length !== 1){
            return Services.HyprlandData.config.gapsOut?.[1] ?? 20
        }
        return gapsOutVertical
    }

    // workspaces
    readonly property int workspacesPadding: 6
    readonly property int workspacesDotSize: 6

    readonly property int notificationsPanelWidth: 300 + gapsOutHorizontal + 10
    readonly property int notificationElementWidth: notificationsPanelWidth - gapsOutHorizontal - 10

    // notifications
    readonly property int notifIconSquare: 22
    readonly property int notifProgressMargin: 16
    readonly property int notifProgressMarginBottom: 16
    readonly property int notifProgressHeight: 3


    // Launcher
    readonly property int launcherInputHeight: 60
    readonly property int launcherInputIconSquare: 30
    readonly property int laucnherYOffset: 100
    readonly property int launcherMaxWidth: 600
    readonly property int launcherMaxHeight: launcherMaxWidth - laucnherYOffset 
}
