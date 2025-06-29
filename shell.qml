import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

import "root:/Modules/Bar" as Modules

ShellRoot {
    property bool enableBar: true




    LazyLoader {
        active: enableBar

        component: Modules.Bar {
        }

    }
}
