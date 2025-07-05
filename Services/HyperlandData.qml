pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    property var windowList: []
    property var addresses: []
    property var windowByAddress: ({})
    property var monitors: []
    property var layers: ({})
    property var workspaces: []
    property var activeWorkspace: {}
    property var workspaceById: ({})

    function updateWindowList() {
        getClients.running = true;
        getMonitors.running = true;
    }

    function updateLayers() {
        getLayers.running = true;
    }

    function updateWorkspaces() {
        getWorkspaces.running = true;
        getActiveWorkspace.running = true;
    }

    Component.onCompleted: {
        updateWindowList();
        updateLayers();
        updateWorkspaces();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            // Filter out redundant old v1 events for the same thing
            if (event.name in ["activewindow", "focusedmon", "monitoradded", "createworkspace", "destroyworkspace", "moveworkspace", "activespecial", "movewindow", "windowtitle"])
                return;
            root.updateWindowList();
            
            // Update workspaces on relevant events
            if (event.name in ["workspace", "createworkspace", "destroyworkspace", "moveworkspace"]) {
                root.updateWorkspaces();
            }
        }
    }

    Process {
        id: getClients
        command: ["bash", "-c", "hyprctl clients -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                root.windowList = JSON.parse(data);
                let tempWinByAddress = {};
                for (var i = 0; i < root.windowList.length; ++i) {
                    var win = root.windowList[i];
                    tempWinByAddress[win.address] = win;
                }
                root.windowByAddress = tempWinByAddress;
                root.addresses = root.windowList.map(win => win.address);
            }
        }
    }

    Process {
        id: getMonitors
        command: ["bash", "-c", "hyprctl monitors -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                root.monitors = JSON.parse(data);
            }
        }
    }

    Process {
        id: getLayers
        command: ["bash", "-c", "hyprctl layers -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                root.layers = JSON.parse(data);
            }
        }
    }

    Process {
        id: getWorkspaces
        command: ["bash", "-c", "hyprctl workspaces -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                root.workspaces = JSON.parse(data);
                let tempWorkspaceById = {};
                for (var i = 0; i < root.workspaces.length; ++i) {
                    var ws = root.workspaces[i];
                    tempWorkspaceById[ws.id] = ws;
                }
                root.workspaceById = tempWorkspaceById;
            }
        }
    }

    Process {
        id: getActiveWorkspace
        command: ["bash", "-c", "hyprctl activeworkspace -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                root.activeWorkspace = JSON.parse(data);
            }
        }
    }
}