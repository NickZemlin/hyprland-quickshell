import QtQuick
import Quickshell
import Quickshell.Io
import "root:/Globals" as Globals
import "root:/Services" as Services

Row {
    id: ramInfo

    // info Variables
    property real ramUsed: 0
    property real swapUsed: 0
    property real cpuLoad: 0
    property int updateInterval: 500

    function updateStats() {
        if (!memInfo.running)
            memInfo.running = true;

        if (!cpuLoadProc.running)
            cpuLoadProc.running = true;

    }

    spacing: Globals.Sizes.gapsIn

    // RAM Block
    SystemInfoBlock {
        iconText: ""
        mainText: `${ramInfo.ramUsed.toFixed(1)} GB`
    }

    // Swap Block
    SystemInfoBlock {
        iconText: "󰯎"
        mainText: `${ramInfo.swapUsed.toFixed(1)} GB`
    }

    // CPU Block
    SystemInfoBlock {
        id: cpuBlock

        iconText: ""
        mainText: `${cpuLoad.toFixed(1)}%`
        mainTextWidth: 45

        customView: Canvas {
            id: cpuChart

            property var history: []
            property int maxHistoryLength: 30
            property real minDisplayPercent: 10
            property real maxDisplayPercent: 90

            function addDataPoint(value) {
                if (history.length >= maxHistoryLength)
                    history.shift();

                history.push(Math.min(100, Math.max(0, value)));
                requestPaint();
            }

            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -Globals.Sizes.borderWidth
            implicitWidth: 100
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                if (history.length < 2)
                    return ;

                var step = width / (maxHistoryLength - 1);
                var baseHeight = height * (1 - minDisplayPercent / 100);
                var topHeight = height * (1 - maxDisplayPercent / 100);
                var points = [];
                for (var i = 0; i < history.length; i++) {
                    var x = i * step;
                    var percent = history[i];
                    var normalized = minDisplayPercent + (percent * (maxDisplayPercent - minDisplayPercent) / 100);
                    var y = height - (normalized / 100 * height);
                    y = Math.max(topHeight, Math.min(baseHeight, y));
                    points.push({
                        "x": x,
                        "y": y
                    });
                }
                // Draw filled area
                ctx.beginPath();
                ctx.fillStyle = Globals.Colors.cpuChartFillColor;
                ctx.moveTo(0, height);
                ctx.lineTo(0, points[0].y);
                for (var i = 1; i < points.length; i++) {
                    ctx.lineTo(points[i].x, points[i].y);
                }
                ctx.lineTo(points[points.length - 1].x, height);
                ctx.closePath();
                ctx.fill();
                // Draw line
                ctx.beginPath();
                ctx.strokeStyle = Globals.Colors.cpuChartLineColor;
                ctx.lineWidth = 2;
                ctx.moveTo(points[0].x, points[0].y);
                for (var i = 1; i < points.length; i++) {
                    ctx.lineTo(points[i].x, points[i].y);
                }
                ctx.stroke();
            }
        }

    }

    // Memory Info Process
    Process {
        id: memInfo

        command: ["bash", "-c", "free -m | awk 'NR==2{printf \"%.1f\", $3/1024; print \"\"; fflush()}; NR==3{printf \"%.1f\", $3/1024}'"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                var results = this.text.trim().split('\n');
                if (results.length >= 2)
                    ramInfo.ramUsed = parseFloat(results[0]);

                ramInfo.swapUsed = parseFloat(results[1]);
            }
        }

    }

    // CPU Load Process
    Process {
        id: cpuLoadProc

        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{printf \"%.1f\", $2 + $4; exit}'"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                var load = parseFloat(this.text.trim());
                cpuLoad = load;
                if (cpuBlock.customItem)
                    cpuBlock.customItem.addDataPoint(load);

            }
        }

    }

    // Update timer
    Timer {
        interval: updateInterval
        running: true
        repeat: true
        onTriggered: updateStats()
    }

}
