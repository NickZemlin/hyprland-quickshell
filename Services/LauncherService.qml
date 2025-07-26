pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "root:/Services" as Services

Singleton {
    id: root

    property bool laucherPresented: false
    property string inputText: ""

    property int selectedIndex: -1 // -1 вместо undefined, более явно, в рот ебал жизнь без опционалов

    property alias list: listModel
    
    ListModel {
        id: listModel
    }

    onInputTextChanged: {
        searchEntries()
    }

    onLaucherPresentedChanged: {
        inputText = ""
        selectedIndex = laucherPresented ? 0 : -1
    }

    GlobalShortcut {
        name: "launcher"
        description: "Toggles launcher"
        onPressed: laucherPresented = !laucherPresented
    }

    function moveUp(){
        if (selectedIndex == 0){
            selectedIndex = list.count - 1
        } else {
            selectedIndex--
        }
    }

    function moveDown(){
        if (selectedIndex == list.count - 1){
            selectedIndex = 0
        } else {
            selectedIndex++
        }
    }

    function performSelectedAction() {
        if (selectedIndex === -1 || selectedIndex >= listModel.count) {
            return
        }

        let item = listModel.get(selectedIndex).launcherItem
        if (item && item.action) {
            item.action()
            laucherPresented = false
        }
    }

    function searchEntries() {
        list.clear()
        
        let result = Services.AppSearch.fuzzyQuery(inputText)
        
        for (let el of result) {
            const item = launcherItemComponent.createObject(root, {
                "elId": el.id,
                "title": el.name,
                "subTitle": el.comment,
                "iconString": el.icon,
                "action": el.execute
            });
            listModel.append({"launcherItem": item});
        }
    }

    component LauncherItem: QtObject {
        id: wrapper
        required property string title
        required property string elId
        required property string subTitle
        required property string iconString
        required property var action
    }

    Component {
        id: launcherItemComponent
        LauncherItem {}
    }
}