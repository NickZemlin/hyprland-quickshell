
function hyprLandColorToQtColor(colorStr, noAlpha = false) {
    // Handle legacy ARGB format (0xAARRGGBB)
    if (colorStr.startsWith("0x")) {
        const argb = colorStr.substring(2); // Remove '0x'
        if (argb.length === 8) {
            const rgb = noAlpha ? argb.substring(2) : argb.substring(2) + argb.substring(0, 2);
            return `#${rgb}`.toLowerCase();
        }
    }
    else if (colorStr.startsWith("rgba(")) {
        const inner = colorStr.substring(5, colorStr.length - 1); // Extract inside rgba(...)
        // Hex format (rgba(b3ff1aee))
        if (/^[0-9a-fA-F]+\)?$/.test(inner)) {
            const hex = inner.padStart(8, 'f'); // Default alpha to 'ff' if missing
            return `#${hex.substring(0, noAlpha ? 6 : 8)}`.toLowerCase();
        }
        // Decimal format (rgba(179,255,26,0.933))
        else if (inner.includes(',')) {
            const parts = inner.split(',');
            if (parts.length >= 3) {
                const r = Math.min(255, Math.max(0, parseInt(parts[0]))) | 0;
                const g = Math.min(255, Math.max(0, parseInt(parts[1]))) | 0;
                const b = Math.min(255, Math.max(0, parseInt(parts[2]))) | 0;
                let result = `#${toHex(r)}${toHex(g)}${toHex(b)}`;
                if (!noAlpha) {
                    const a = parts.length >= 4 ? 
                        Math.min(255, Math.max(0, Math.round(parseFloat(parts[3]) * 255))) | 0 : 
                        255;
                    result += toHex(a);
                }
                return result.toLowerCase();
            }
        }
    }
    else if (colorStr.startsWith("rgb(")) {
        const inner = colorStr.substring(4, colorStr.length - 1); // Extract inside rgb(...)
        // Hex format (rgb(b3ff1a))
        if (/^[0-9a-fA-F]+\)?$/.test(inner)) {
            return `#${inner.padEnd(6, '0')}${noAlpha ? '' : 'ff'}`.toLowerCase();
        }
        // Decimal format (rgb(179,255,26))
        else if (inner.includes(',')) {
            const parts = inner.split(',');
            if (parts.length >= 3) {
                const r = Math.min(255, Math.max(0, parseInt(parts[0]))) | 0;
                const g = Math.min(255, Math.max(0, parseInt(parts[1]))) | 0;
                const b = Math.min(255, Math.max(0, parseInt(parts[2]))) | 0;
                return `#${toHex(r)}${toHex(g)}${toHex(b)}${noAlpha ? '' : 'ff'}`.toLowerCase();
            }
        }
    }
    else if (colorStr.startsWith("#")) {
        if (noAlpha) {
            return colorStr.length === 9 ? `#${colorStr.substring(1, 7)}`.toLowerCase() : colorStr.toLowerCase();
        } else {
            return colorStr.length === 7 ? `${colorStr}ff`.toLowerCase() : colorStr.toLowerCase();
        }
    }
    return colorStr.toLowerCase();
}

// Helper: Convert number (0-255) to 2-digit hex
function toHex(num) {
    return num.toString(16).padStart(2, '0');
}

/**
 * Mixes two colors by a given percentage.
 *
 * @param {string} color1 - The first color (any Qt.color-compatible string).
 * @param {string} color2 - The second color.
 * @param {number} percentage - The mix ratio (0-1). 1 = all color1, 0 = all color2.
 * @returns {Qt.rgba} The resulting mixed color.
 */
function mix(color1, color2, percentage = 0.5) {
    var c1 = Qt.color(color1);
    var c2 = Qt.color(color2);
    return Qt.rgba(percentage * c1.r + (1 - percentage) * c2.r, percentage * c1.g + (1 - percentage) * c2.g, percentage * c1.b + (1 - percentage) * c2.b, percentage * c1.a + (1 - percentage) * c2.a);
}