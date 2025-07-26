pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "root:/Assets/Wallpapers" as Wallpapers
import "root:/Services" as Services

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
    property var config: Config {}

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
    
    function updateConfig() {
        configParser.running = true;
    }

    function updateAll() {
        updateWindowList();
        updateLayers();
        updateWorkspaces();
    }

    Component.onCompleted: {
        updateAll();
        updateConfig();
        refreshTimer.start();
    }

    Timer {
        id: refreshTimer
        interval: 1000  // Refresh every second
        repeat: false
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
                // Services.LauncherService.laucherPresented = false
            }
            
            // Update config on reload event
            if (event.name === "configreloaded") {
                root.updateConfig();
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

    component Config: QtObject {
        property var gapsIn: null
        property var gapsOut: null
        property var borderSize: null
        property var borderRadius: null

        property var activeBorderColor: null
        property var inactiveBorderColor: null
    }

    Process {
        id: configParser

        property var options: {
            "general:gaps_in": "gapsIn",
            "general:gaps_out": "gapsOut",
            "general:border_size": "borderSize",
            "decoration:rounding": "borderRadius",
            "general:col.active_border": "activeBorderColor",
            "general:col.inactive_border": "inactiveBorderColor",
        }

        command: ["hyprctl", "--batch", "-j", Object.keys(options).map((x) => `getoption ${x}`).join(";")]

        stdout: SplitParser {
            onRead: data => {
                let content = data.trim()
                if (content == '') {
                    return
                }

                let parsed = JSON.parse(content);
                let entry = configParser.options[parsed['option']]

                if (parsed.set) {
                    if ('int' in parsed) {
                        root.config[entry] = parsed.int
                    } else if ('custom' in parsed) {
                        root.config[entry] = parsed.custom.split(' ')
                    } else {
                        console.error(`Invalid option response: ${content}`)
                    }
                } else {
                    root.config[entry] = null
                }
            }
        }
    }
}

