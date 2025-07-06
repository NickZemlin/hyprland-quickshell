import QtQuick
import Quickshell.Hyprland
import "root:/Globals" as Globals
import "root:/Services" as Services

Rectangle {
    id: workspacesRoot
    
    width: row.childrenRect.width + row.spacing * 2
    height: Globals.Sizes.barBlockHeihgt
    radius: Globals.Sizes.barBlockHeihgt / 2
    color: "transparent"

    Row {
        id: row
        spacing: Globals.Sizes.gapsOut / 2
        anchors.centerIn: parent
        
        Repeater {
            model: 10  // Always show 10 workspaces
            
            WorkspaceWrapper {
                required property int index
                
                workspaceId: index + 1  // Workspace IDs start at 1
                isActive: {
                    return Services.HyprlandData.activeWorkspace && 
                           Services.HyprlandData.activeWorkspace.id === (index + 1);
                }
                numberOfChildren: workspacesRoot.getWindowCount(index + 1)
                biggestWindow: workspacesRoot.getBiggestWindow(index + 1)
                isInitialized: workspacesRoot.isWorkspaceInitialized(index + 1)
            }
        }
    }
    
    function isWorkspaceInitialized(workspaceId) {
        if (!Services.HyprlandData.workspaces) return false;
        
        return Services.HyprlandData.workspaces.some(ws => ws.id === workspaceId);
    }
    
    function getWindowCount(workspaceId) {
        if (!Services.HyprlandData.windowList) return 0;
        
        return Services.HyprlandData.windowList.filter(win => 
            win.workspace && win.workspace.id === workspaceId
        ).length;
    }
    
    function getBiggestWindow(workspaceId) {
        if (!Services.HyprlandData.windowList) return null;
        
        let windows = Services.HyprlandData.windowList.filter(win => 
            win.workspace && win.workspace.id === workspaceId
        );
        
        if (windows.length === 0) return null;
        
        return windows.reduce((biggest, current) => {
            let biggestArea = biggest.size[0] * biggest.size[1];
            let currentArea = current.size[0] * current.size[1];
            return currentArea > biggestArea ? current : biggest;
        });
    }
}
