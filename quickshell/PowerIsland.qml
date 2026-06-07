import QtQuick
import Quickshell.Io

Rectangle {
    id: powerIsland
    height: parent.height
    color: "#212121"
    radius: 10
    implicitWidth: 36

    property bool popupVisible: false

    function doSuspend() { suspendProcess.running = true }
    function doShutdown() { shutdownProcess.running = true }

    Process {
        id: suspendProcess
        command: ["systemctl", "suspend"]
        running: false
    }

    Process {
        id: shutdownProcess
        command: ["systemctl", "poweroff"]
        running: false
    }

    Text {
        anchors.centerIn: parent
        text: "⏻"
        color: btnHover.hovered ? "#aaaaaa" : "white"
        font.family: "FiraCode Nerd Font"
        font.pixelSize: 16
        font.weight: Font.DemiBold
    }

    HoverHandler { id: btnHover }

    TapHandler {
        onTapped: powerIsland.popupVisible = !powerIsland.popupVisible
    }
}
