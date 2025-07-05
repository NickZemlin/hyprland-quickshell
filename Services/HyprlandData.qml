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
    property var activeWorkspace: ({id: -1})  // Initialize with default
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

    function updateAll() {
        updateWindowList();
        updateLayers();
        updateWorkspaces();
    }

    Component.onCompleted: {
        updateAll();
        // Set up periodic refresh as backup
        refreshTimer.start();
    }

    Timer {
        id: refreshTimer
        interval: 1000  // Refresh every second
        repeat: true
        onTriggered: {
            if (!getWorkspaces.running && !getActiveWorkspace.running && !getClients.running) {
                updateAll();
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            
            // Update window list on relevant events
            if (event.name === "openwindow" || 
                event.name === "closewindow" || 
                event.name === "movewindow" || 
                event.name === "windowtitle" ||
                event.name === "activewindowv2") {
                root.updateWindowList();
            }
            
            // Update workspaces on relevant events
            if (event.name === "workspace" || 
                event.name === "createworkspace" || 
                event.name === "destroyworkspace" || 
                event.name === "moveworkspace" ||
                event.name === "workspacev2") {
                root.updateWorkspaces();
            }
        }
    }

    Process {
        id: getClients
        command: ["bash", "-c", "hyprctl clients -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.windowList = JSON.parse(data);
                    let tempWinByAddress = {};
                    for (var i = 0; i < root.windowList.length; ++i) {
                        var win = root.windowList[i];
                        tempWinByAddress[win.address] = win;
                    }
                    root.windowByAddress = tempWinByAddress;
                    root.addresses = root.windowList.map(win => win.address);
                } catch (e) {
                    console.error("Error parsing clients:", e);
                }
            }
        }
    }

    Process {
        id: getMonitors
        command: ["bash", "-c", "hyprctl monitors -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.monitors = JSON.parse(data);
                } catch (e) {
                    console.error("Error parsing monitors:", e);
                }
            }
        }
    }

    Process {
        id: getLayers
        command: ["bash", "-c", "hyprctl layers -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.layers = JSON.parse(data);
                } catch (e) {
                    console.error("Error parsing layers:", e);
                }
            }
        }
    }
Process {
        id: getWorkspaces
        command: ["bash", "-c", "hyprctl workspaces -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.workspaces = JSON.parse(data);
                    let tempWorkspaceById = {};
                    for (var i = 0; i < root.workspaces.length; ++i) {
                        var ws = root.workspaces[i];
                        tempWorkspaceById[ws.id] = ws;
                    }
                    root.workspaceById = tempWorkspaceById;
                } catch (e) {
                    console.error("Error parsing workspaces:", e);
                }
            }
        }
    }

    Process {
        id: getActiveWorkspace
        command: ["bash", "-c", "hyprctl activeworkspace -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.activeWorkspace = JSON.parse(data);
                } catch (e) {
                    console.error("Error parsing active workspace:", e);
                }
            }
        }
    }
}