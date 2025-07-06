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
    const c1 = Qt.color(color1);
    const c2 = Qt.color(color2);
    return Qt.rgba(percentage * c1.r + (1 - percentage) * c2.r, percentage * c1.g + (1 - percentage) * c2.g, percentage * c1.b + (1 - percentage) * c2.b, percentage * c1.a + (1 - percentage) * c2.a);
}
