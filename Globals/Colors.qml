import QtQuick
import Quickshell
import "root:/Helpers/ColorHelpers.js" as Helpers
import "root:/Services" as Services
pragma Singleton

Singleton {
    // Base colors from Catppuccin Mocha
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"
    readonly property color text: "#cdd6f4"
    readonly property color subtext1: "#bac2de"
    readonly property color subtext0: "#a6adc8"
    readonly property color overlay2: "#9399b2"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay0: "#6c7086"
    readonly property color surface2: "#585b70"
    readonly property color surface1: "#45475a"
    readonly property color surface0: "#313244"
    readonly property color blue: "#89b4fa"
    readonly property color lavender: "#b4befe"
    readonly property color sapphire: "#74c7ec"
    readonly property color sky: "#89dceb"
    readonly property color teal: "#94e2d5"
    readonly property color green: "#a6e3a1"
    readonly property color yellow: "#f9e2af"
    readonly property color peach: "#fab387"
    readonly property color maroon: "#eba0ac"
    readonly property color red: "#f38ba8"
    readonly property color mauve: "#cba6f7"
    readonly property color pink: "#f5c2e7"
    readonly property color flamingo: "#f2cdcd"
    readonly property color rosewater: "#f5e0dc"
    readonly property color barElementBackground: surface0
    readonly property color barElementHovered: surface1
    readonly property color cpuChartLineColor: barElementActiveBorderColor
    readonly property color cpuChartFillColor: surface2
    readonly property color barElementBackgroundColor: surface0
    readonly property color barElementBorderColor: {
        if (Services.HyprlandData.config && Services.HyprlandData.config.general && Services.HyprlandData.config.general['col.inactive_border']) {
            let activeColor = Services.HyprlandData.config.general['col.inactive_border'].split(" ")[0];
            if (activeColor)
                return String(Helpers.hyprLandColorToQtColor(activeColor, true));

        }
        return text;
    }
    readonly property color barElementActiveBorderColor: {
        if (Services.HyprlandData.config && Services.HyprlandData.config.general && Services.HyprlandData.config.general['col.active_border']) {
            let activeColor = Services.HyprlandData.config.general['col.active_border'].split(" ")[0];
            if (activeColor)
                return String(Helpers.hyprLandColorToQtColor(activeColor, true));

        }
        return maroon;
    }
    readonly property color barElementHoveredBorderColor: {
        return Helpers.mix(barElementBorderColor, barElementActiveBorderColor, 0.7);
    }
    readonly property color barElementTextColor: text
    // workspaces
    readonly property color workspaceActive: surface1
    readonly property color workspaceInactive: surface0
    readonly property color workspaceFallbackRect: lavender
    readonly property color workspaceFallbackRectText: text
    readonly property color workspaceDotActive: barElementActiveBorderColor
    readonly property color workspaceDotInactive: barElementBorderColor
    readonly property color workspaceNumberOfWindows: text
}
