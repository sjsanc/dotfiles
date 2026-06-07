import QtQuick
import Quickshell.Io

Rectangle {
    id: sysIsland
    height: parent.height
    color: "#212121"
    radius: 10
    implicitWidth: sysRow.implicitWidth + 24

    property var prevCpuStats: []
    property int cpuUsage: 0
    property int memUsage: 0
    property int diskUsage: 0

    Process {
        id: cpuProcess
        command: ["bash", "-c", "awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8; exit}' /proc/stat"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(" ").map(Number)
                if (sysIsland.prevCpuStats.length === 7) {
                    var idleDiff = parts[3] - sysIsland.prevCpuStats[3]
                    var totalDiff = 0
                    for (var i = 0; i < 7; i++) totalDiff += parts[i] - sysIsland.prevCpuStats[i]
                    sysIsland.cpuUsage = totalDiff > 0 ? Math.round(100 * (1 - idleDiff / totalDiff)) : 0
                }
                sysIsland.prevCpuStats = parts
            }
        }
    }

    Process {
        id: memProcess
        command: ["bash", "-c", "awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print int((t-a)*100/t)}' /proc/meminfo"]
        running: true
        stdout: SplitParser {
            onRead: data => { sysIsland.memUsage = parseInt(data.trim()) }
        }
    }

    Process {
        id: diskProcess
        command: ["bash", "-c", "df /home --output=pcent | tail -1 | tr -d ' %'"]
        running: true
        stdout: SplitParser {
            onRead: data => { sysIsland.diskUsage = parseInt(data.trim()) }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (!cpuProcess.running) cpuProcess.running = true
            if (!memProcess.running) memProcess.running = true
            if (!diskProcess.running) diskProcess.running = true
        }
    }

    Row {
        id: sysRow
        anchors.centerIn: parent
        spacing: 12

        Text {
            height: 32
            verticalAlignment: Text.AlignVCenter
            text: "󰻠 " + sysIsland.cpuUsage + "%"
            color: "white"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        Text {
            height: 32
            verticalAlignment: Text.AlignVCenter
            text: "󰍛 " + sysIsland.memUsage + "%"
            color: "white"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        Text {
            height: 32
            verticalAlignment: Text.AlignVCenter
            text: "󰋊 " + sysIsland.diskUsage + "%"
            color: "white"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }
    }
}
