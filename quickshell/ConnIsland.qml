import QtQuick
import Quickshell.Io

Rectangle {
    id: connIsland
    height: parent.height
    color: "#212121"
    radius: 10
    implicitWidth: connRow.implicitWidth + 8

    property string btState: "off"
    property string netState: "disconnected"
    property bool netPopupVisible: false
    property string netInfo1: ""
    property string netInfo2: ""
    property bool btPopupVisible: false
    property var btDevices: []

    property alias netAnchorItem: netWrapper
    property alias btAnchorItem: btWrapper

    Process {
        id: btProcess
        command: ["bash", "-c", "if bluetoothctl show 2>/dev/null | grep -q 'Powered: yes'; then bluetoothctl devices Connected 2>/dev/null | grep -q Device && echo connected || echo on; else echo off; fi"]
        running: true
        stdout: SplitParser {
            onRead: data => { connIsland.btState = data.trim() }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) connIsland.btState = "off"
        }
    }

    Process {
        id: btDevicesProcess
        command: ["bash", "-c", "bluetoothctl devices Connected 2>/dev/null | sed 's/Device [^ ]* //' | grep ."]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var name = data.trim()
                if (name !== "") connIsland.btDevices = [...connIsland.btDevices, name]
            }
        }
    }

    Process {
        id: netProcess
        command: ["bash", "-c", "if ip link | grep 'state UP' | grep -q 'wl'; then echo wifi; elif ip link | grep 'state UP' | grep -qE ' en| eth'; then echo ethernet; else echo disconnected; fi"]
        running: true
        stdout: SplitParser {
            onRead: data => { connIsland.netState = data.trim() }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) connIsland.netState = "disconnected"
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (!btProcess.running) btProcess.running = true
            if (!netProcess.running) netProcess.running = true
        }
    }

    Process {
        id: netSsidProcess
        command: ["bash", "-c", "IFACE=$(ip -o link show | grep 'state UP' | grep -o 'wl[^:]*' | head -1); SSID=''; if [ -n \"$IFACE\" ]; then SSID=$(iwctl station \"$IFACE\" show 2>/dev/null | sed 's/\\x1b\\[[0-9;]*[mGKH]//g' | awk '/Connected network/{print $NF}'); fi; [ -n \"$SSID\" ] && echo \"$SSID\" || echo ?"]
        running: false
        stdout: SplitParser {
            onRead: data => { connIsland.netInfo1 = data.trim() }
        }
    }

    Process {
        id: netDetailProcess
        command: ["bash", "-c", "IFACE=$(ip -o link show | grep 'state UP' | grep -o 'wl[^:]*' | head -1); FREQ=''; if [ -n \"$IFACE\" ]; then FREQ=$(iwctl station \"$IFACE\" show 2>/dev/null | sed 's/\\x1b\\[[0-9;]*[mGKH]//g' | awk '/Frequency/{print $NF}'); fi; IP=$(ip -o -4 addr show $(ip -o -4 route show to default 2>/dev/null | awk '{print $5}' | head -1) 2>/dev/null | awk '{print $4}' | cut -d/ -f1); if [ -n \"$FREQ\" ]; then [ \"$FREQ\" -ge 5000 ] && echo \"5GHz · ${IP:-?}\" || echo \"2.4GHz · ${IP:-?}\"; else echo \"${IP:-?}\"; fi"]
        running: false
        stdout: SplitParser {
            onRead: data => { connIsland.netInfo2 = data.trim() }
        }
    }

    Row {
        id: connRow
        anchors.centerIn: parent
        spacing: 4

        Rectangle {
            id: btWrapper
            width: 32; height: 32; radius: 6
            color: btIconHover.hovered ? "#595450" : "transparent"
            Text {
                anchors.centerIn: parent
                text: connIsland.btState === "connected" ? "󰂱" : connIsland.btState === "on" ? "󰂯" : "󰂲"
                color: connIsland.btState === "connected" ? "#60a5fa" : connIsland.btState === "on" ? "white" : "#585858"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 16
                font.weight: Font.DemiBold
            }
            HoverHandler {
                id: btIconHover
                onHoveredChanged: {
                    if (hovered) {
                        connIsland.btDevices = []
                        if (!btDevicesProcess.running) btDevicesProcess.running = true
                        connIsland.btPopupVisible = true
                    } else {
                        connIsland.btPopupVisible = false
                    }
                }
            }
        }

        Rectangle {
            id: netWrapper
            width: 32; height: 32; radius: 6
            color: netIconHover.hovered ? "#595450" : "transparent"

            Text {
                anchors.centerIn: parent
                text: connIsland.netState === "wifi" ? "󰖩" : connIsland.netState === "ethernet" ? "󰈀" : "󰖪"
                color: connIsland.netState !== "disconnected" ? "#84cc16" : "#585858"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 16
                font.weight: Font.DemiBold
            }

            HoverHandler {
                id: netIconHover
                onHoveredChanged: {
                    if (hovered) {
                        connIsland.netInfo1 = ""
                        connIsland.netInfo2 = ""
                        if (!netSsidProcess.running) netSsidProcess.running = true
                        if (!netDetailProcess.running) netDetailProcess.running = true
                        connIsland.netPopupVisible = true
                    } else {
                        connIsland.netPopupVisible = false
                    }
                }
            }
        }
    }
}
