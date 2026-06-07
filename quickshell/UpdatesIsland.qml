import QtQuick
import Quickshell.Io

Rectangle {
    id: updatesIsland
    height: parent.height
    color: "#212121"
    radius: 10
    implicitWidth: updatesWrapper.implicitWidth + 8

    property string updatesCount: "?"
    property string updatesText: ""
    property bool popupVisible: false
    property string _pkgBuffer: ""

    Process {
        id: updatesProcess
        command: ["bash", "-c", "cat /tmp/qs-updates.list 2>/dev/null || true"]
        running: false
        onRunningChanged: if (running) updatesIsland._pkgBuffer = ""
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() !== "")
                    updatesIsland._pkgBuffer += (updatesIsland._pkgBuffer ? "\n" : "") + data.trim()
            }
        }
        onExited: {
            updatesIsland.updatesText = updatesIsland._pkgBuffer
            var lines = updatesIsland._pkgBuffer.trim() === "" ? [] : updatesIsland._pkgBuffer.trim().split("\n")
            updatesIsland.updatesCount = String(lines.length)
            updatesIsland._pkgBuffer = ""
        }
    }

    Timer {
        interval: 1800000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!updatesProcess.running) updatesProcess.running = true
        }
    }

    Rectangle {
        id: updatesWrapper
        anchors.centerIn: parent
        height: 32
        implicitWidth: updatesLabel.implicitWidth + 16
        radius: 6
        color: updatesIslandHover.hovered ? "#595450" : "transparent"

        Text {
            id: updatesLabel
            anchors.centerIn: parent
            text: "󰚰 " + updatesIsland.updatesCount
            color: updatesIsland.updatesCount !== "0" ? "white" : "#585858"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        HoverHandler { id: updatesIslandHover }

        TapHandler {
            onTapped: updatesIsland.popupVisible = !updatesIsland.popupVisible
        }
    }
}
