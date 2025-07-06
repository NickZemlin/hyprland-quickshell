pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "root:/Assets/Wallpapers" as Wallpapers

Singleton {
    id: root

    // Current wallpaper and theme properties
    property var currentWallpaper: Wallpapers.RegistredWallpapers.papers[0]
    property var hyprlandColors: {
        "active": "#83A598",   // Default active border color
        "inactive": "#3C3836"  // Default inactive border color
    }

    // Process for extracting colors from wallpaper
    Process {
        id: extractProcess
        property string outputBuffer: ""

        stdout: SplitParser {
            onRead: data => {
                extractProcess.outputBuffer += data;
            }
        }
    }

    // Properly parented Connections object
    Connections {
        target: extractProcess

        function onExited() {
            if (extractProcess.outputBuffer.trim()) {
                // Process the output to extract colors
                const colors = parseImageMagickOutput(extractProcess.outputBuffer);
                if (colors.length > 0) {
                    // Generate and apply border colors
                    const borderColors = generateHyprlandBorderColors(colors);
                    root.hyprlandColors = borderColors;
                    applyHyprlandColors(borderColors);
                }
            }
            extractProcess.outputBuffer = "";
        }
    }

    // Process for applying Hyprland settings
    Process {
        id: hyprlandProcess
    }


    Connections {
        target: hyprlandProcess

        function onExited() {
            HyprlandData.updateConfig()
        }
    }

    // Function to set wallpaper by name
    function setWallpaperByName(name) {
        for (let i = 0; i < Wallpapers.RegistredWallpapers.papers.length; i++) {
            if (Wallpapers.RegistredWallpapers.papers[i].name === name) {
                currentWallpaper = Wallpapers.RegistredWallpapers.papers[i];
                extractColorsFromWallpaper(currentWallpaper.path);
                return true;
            }
        }
        return false;
    }

    // Extract colors from wallpaper
    function extractColorsFromWallpaper(wallpaperPath) {
        // Remove 'root:/' prefix if present
        const processedPath = wallpaperPath.replace('root:/', '');

        // Command to extract dominant colors using ImageMagick
        extractProcess.command = ["bash", "-c",
            `magick convert "${processedPath}" -resize 100x100 -colors 10 -unique-colors txt:-`];
        extractProcess.outputBuffer = "";
        extractProcess.running = true;
    }

    function applyHyprlandColors(colors) {
        // Apply active and inactive border colors in a single batch command
        hyprlandProcess.command = [
            "hyprctl", 
            "--batch", 
            `keyword general:col.active_border ${colors.active} ; keyword general:col.inactive_border ${colors.inactive}`
        ];
        hyprlandProcess.running = true;
    }

    // Parse ImageMagick output to get RGB colors
    function parseImageMagickOutput(output) {
        const colors = [];

        // Look for all hex color codes
        const hexRegex = /#[0-9A-Fa-f]{6}/g;
        let match;
        let hexMatches = [];
        
        // Use exec in a loop to find all matches
        while ((match = hexRegex.exec(output)) !== null) {
            hexMatches.push(match[0]);
        }
                
        for (const hex of hexMatches) {
            const rgb = hexToRgb(hex);
            if (rgb) {
                colors.push(rgb);
            }
        }
        
        return colors;
    }



    // Convert hex color to RGB array
    function hexToRgb(hex) {
        // Remove # if present
        hex = hex.replace(/^#/, '');

        // Parse the hex values
        const r = parseInt(hex.substring(0, 2), 16);
        const g = parseInt(hex.substring(2, 4), 16);
        const b = parseInt(hex.substring(4, 6), 16);

        // Check if parsing was successful
        if (isNaN(r) || isNaN(g) || isNaN(b)) {
            return null;
        }

        return [r, g, b];
    }

    // Convert RGB to hexadecimal
    function rgbToHex(r, g, b) {
        return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
    }

    // Calculate color brightness (0-255)
    function getBrightness(r, g, b) {
        return (r * 299 + g * 587 + b * 114) / 1000;
    }

    // Calculate color saturation (0-1)
    function getSaturation(r, g, b) {
        const max = Math.max(r, g, b);
        const min = Math.min(r, g, b);

        if (max === 0) return 0;

        return (max - min) / max;
    }

    // Generate Hyprland border colors from dominant colors with gradients
    function generateHyprlandBorderColors(dominantColors) {
        if (!dominantColors || dominantColors.length === 0) {
            return {
                active: "rgb(131,165,152) rgb(104,157,106) 45deg",  // Gradient from light to dark green
                inactive: "rgb(60,56,54) rgb(40,40,40) 45deg"       // Gradient from dark to darker gray
            };
        }

        // Log all colors
        dominantColors.forEach((color, index) => {
        });

        // Sort by saturation for active border (more saturated)
        const sortedBySaturation = [...dominantColors];
        sortedBySaturation.sort((a, b) => {
            return getSaturation(b[0], b[1], b[2]) - getSaturation(a[0], a[1], a[2]);
        });
        
        // Log sorted colors by saturation
        sortedBySaturation.forEach((color, index) => {
        });

        // Sort by brightness for inactive border (less bright)
        const sortedByBrightness = [...dominantColors];
        sortedByBrightness.sort((a, b) => {
            return getBrightness(a[0], a[1], a[2]) - getBrightness(b[0], b[1], b[2]);
        });
        

        // Get active color (high saturation but visible)
        let activeBorderColor1 = sortedBySaturation[0];
        
        // Ensure active color has sufficient brightness
        if (getBrightness(activeBorderColor1[0], activeBorderColor1[1], activeBorderColor1[2]) < 50) {
            // If too dark, use the next most saturated color
            for (let i = 1; i < sortedBySaturation.length; i++) {
                if (getBrightness(sortedBySaturation[i][0], sortedBySaturation[i][1], sortedBySaturation[i][2]) >= 50) {
                    activeBorderColor1 = sortedBySaturation[i];
                    break;
                }
            }
        }
        
        // Find a complementary color for the gradient (next most saturated with good brightness)
        let activeBorderColor2 = null;
        for (let i = 1; i < sortedBySaturation.length; i++) {
            const color = sortedBySaturation[i];
            // Skip if too similar to first color
            const colorDistance = getColorDistance(activeBorderColor1, color);
            if (colorDistance > 30 && getBrightness(color[0], color[1], color[2]) >= 50) {
                activeBorderColor2 = color;
                break;
            }
        }
        
        // If no good complement found, create a slightly darker/lighter version of the first color
        if (!activeBorderColor2) {
            const brightness = getBrightness(activeBorderColor1[0], activeBorderColor1[1], activeBorderColor1[2]);
            if (brightness > 150) {
                // For bright colors, make a darker version
                activeBorderColor2 = [
                    Math.max(0, Math.round(activeBorderColor1[0] * 0.7)),
                    Math.max(0, Math.round(activeBorderColor1[1] * 0.7)),
                    Math.max(0, Math.round(activeBorderColor1[2] * 0.7))
                ];
            } else {
                // For darker colors, make a brighter version
                activeBorderColor2 = [
                    Math.min(255, Math.round(activeBorderColor1[0] * 1.3)),
                    Math.min(255, Math.round(activeBorderColor1[1] * 1.3)),
                    Math.min(255, Math.round(activeBorderColor1[2] * 1.3))
                ];
            }
        }

        // Get inactive color (lower brightness but not too dark)
        let inactiveBorderColor1 = sortedByBrightness[Math.floor(sortedByBrightness.length / 3)];
        
        // Find a second color for inactive gradient (darker or similar tone)
        let inactiveBorderColor2 = sortedByBrightness[Math.floor(sortedByBrightness.length / 4)];
        if (getColorDistance(inactiveBorderColor1, inactiveBorderColor2) < 20) {
            // If too similar, create a darker version
            inactiveBorderColor2 = [
                Math.max(0, Math.round(inactiveBorderColor1[0] * 0.7)),
                Math.max(0, Math.round(inactiveBorderColor1[1] * 0.7)),
                Math.max(0, Math.round(inactiveBorderColor1[2] * 0.7))
            ];
        } else {
        }
        
        const colors = {
            active: `rgb(${activeBorderColor1[0]},${activeBorderColor1[1]},${activeBorderColor1[2]}) rgb(${activeBorderColor2[0]},${activeBorderColor2[1]},${activeBorderColor2[2]}) 45deg`,
            inactive: `rgb(${inactiveBorderColor1[0]},${inactiveBorderColor1[1]},${inactiveBorderColor1[2]}) rgb(${inactiveBorderColor2[0]},${inactiveBorderColor2[1]},${inactiveBorderColor2[2]}) 45deg`
        };
        
        return colors;
    }

    // Helper function to calculate color distance (Euclidean distance in RGB space)
    function getColorDistance(color1, color2) {
        const rDiff = color1[0] - color2[0];
        const gDiff = color1[1] - color2[1];
        const bDiff = color1[2] - color2[2];
        return Math.sqrt(rDiff*rDiff + gDiff*gDiff + bDiff*bDiff);
    }



    // Initialize when component is loaded
    Component.onCompleted: {
        // Extract colors from initial wallpaper
        extractColorsFromWallpaper(currentWallpaper.path);
    }
}