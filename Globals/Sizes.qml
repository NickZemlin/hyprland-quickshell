pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property int barHeight: 30
    readonly property int barBlockHeihgt: barHeight - 2
    readonly property int barItemInnerPadding: 4

    // workspaces
    readonly property int workspacesPadding: 6
    readonly property int workspacesDotSize: 6
}