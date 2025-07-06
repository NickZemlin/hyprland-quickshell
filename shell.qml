import Quickshell

import "root:/Modules/Bar" as Modules

ShellRoot {
    id: root
    property bool enableBar: true

    LazyLoader {
        active: root.enableBar

        component: Modules.Bar {}
    }
}
