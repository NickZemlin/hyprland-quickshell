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
    property var config: ({})

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
        getConfig.running = true;
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
    
Process {
    id: getConfig
    property string fullConfig: ""
    property bool isRunning: false
    
    command: ["bash", "-c", "cat ~/.config/hypr/hyprland.conf"]
    
    onRunningChanged: {
        if (isRunning && !running) {
            try {
                let configData = parseHyprlandConfig(fullConfig);
                root.config = configData;
                
                fullConfig = "";
            } catch (e) {
                console.error("Error parsing hyprland config:", e);
                fullConfig = "";
            }
            isRunning = false;
        } else if (running) {
            isRunning = true;
            fullConfig = ""; 
        }
    }
    
    stdout: SplitParser {
        onRead: data => {
            getConfig.fullConfig += data + "\n";
        }
    }
    
    function parseHyprlandConfig(data) {
        let configSections = {};
        let currentSection = null;
        let sectionContent = {};
        let inSection = false;
        
        const lines = data.split('\n');
        
        for (let line of lines) {
            line = line.trim();
            
            if (line === '' || line.startsWith('#')) {
                continue;
            }
            
            const sectionMatch = line.match(/^(\w+)\s*{$/);
            if (sectionMatch) {
                if (currentSection) {
                    configSections[currentSection] = sectionContent;
                }
                
                currentSection = sectionMatch[1];
                sectionContent = {};
                inSection = true;
                continue;
            }
            
            if (line === '}' && inSection) {
                configSections[currentSection] = sectionContent;
                currentSection = null;
                sectionContent = {};
                inSection = false;
                continue;
            }
            
            if (inSection) {
                const keyValueMatch = line.match(/^([^=]+)=(.*)$/);
                if (keyValueMatch) {
                    const key = keyValueMatch[1].trim();
                    const value = keyValueMatch[2].trim();
                    sectionContent[key] = value;
                } else {
                    const spaceKeyValueMatch = line.match(/^([^\s]+)\s+(.+)$/);
                    if (spaceKeyValueMatch) {
                        const key = spaceKeyValueMatch[1].trim();
                        const value = spaceKeyValueMatch[2].trim();
                        sectionContent[key] = value;
                    }
                }
            }
        }
        
        if (currentSection) {
            configSections[currentSection] = sectionContent;
        }
        
        return configSections;
    }
}
}