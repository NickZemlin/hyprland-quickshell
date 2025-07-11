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
}
