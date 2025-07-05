pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property color barElementBackground: "lightGray"
    readonly property color barElementHovered: "gray"
    readonly property color cpuChartLineColor: "black"
    readonly property color cpuChartFillColor: "red"

    // workspaces
    readonly property color workspaceActive: "#595959"
    readonly property color workspaceInactive: "#595959"
    readonly property color workspaceFallbackRect: "#393939"
    readonly property color workspaceFallbackRectText: "#ffffff"
    readonly property color workspaceDotActive: "#ffffff"
    readonly property color workspaceDotInactive: "#AAAAAA"
    readonly property color workspaceNumberOfWindows: "#AAAAAA"
}