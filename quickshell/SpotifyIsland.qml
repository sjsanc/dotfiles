import QtQuick
import Quickshell.Io
import Quickshell.Widgets

Rectangle {
    id: spotifyIsland
    color: "#212121"
    radius: 10
    height: parent.height
    implicitWidth: spotifyRow.implicitWidth + 8

    property string spotifyMeta: "—"
    property string spotifyStatus: "stopped"
    property string spotifyArtUrl: ""

    Process {
        id: artProcess
        command: ["playerctl", "-p", "spotify", "metadata", "mpris:artUrl"]
        running: true
        stdout: SplitParser {
            onRead: data => { spotifyIsland.spotifyArtUrl = data }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) spotifyIsland.spotifyArtUrl = ""
        }
    }

    Process {
        id: metaProcess
        command: ["bash", "-c", "TITLE=$(playerctl -p spotify metadata xesam:title 2>/dev/null); ARTIST=$(playerctl -p spotify metadata xesam:artist 2>/dev/null); [ -n \"$TITLE\" ] && echo \"$TITLE - $ARTIST\" || echo '—'"]
        running: true
        stdout: SplitParser {
            onRead: data => { spotifyIsland.spotifyMeta = data }
        }
    }

    Process {
        id: statusProcess
        command: ["playerctl", "-p", "spotify", "status"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data === "Playing") spotifyIsland.spotifyStatus = "playing"
                else if (data === "Paused") spotifyIsland.spotifyStatus = "paused"
                else spotifyIsland.spotifyStatus = "stopped"
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) spotifyIsland.spotifyStatus = "stopped"
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (!artProcess.running) artProcess.running = true
            if (!metaProcess.running) metaProcess.running = true
            if (!statusProcess.running) statusProcess.running = true
        }
    }

    Process {
        id: prevProcess
        command: ["playerctl", "-p", "spotify", "previous"]
        running: false
        onExited: (exitCode, exitStatus) => {
            if (!statusProcess.running) statusProcess.running = true
        }
    }

    Process {
        id: nextProcess
        command: ["playerctl", "-p", "spotify", "next"]
        running: false
        onExited: (exitCode, exitStatus) => {
            if (!statusProcess.running) statusProcess.running = true
        }
    }

    Process {
        id: toggleProcess
        command: ["playerctl", "-p", "spotify", "play-pause"]
        running: false
        onExited: (exitCode, exitStatus) => {
            if (!statusProcess.running) statusProcess.running = true
        }
    }

    Row {
        id: spotifyRow
        anchors.centerIn: parent
        spacing: 8

        ClippingWrapperRectangle {
            width: 32; height: 32
            radius: 6
            visible: spotifyIsland.spotifyArtUrl !== "" && spotifyIsland.spotifyStatus !== "stopped"

            Image {
                anchors.fill: parent
                source: spotifyIsland.spotifyArtUrl
                fillMode: Image.PreserveAspectCrop
                smooth: true
                cache: false
            }
        }

        Text {
            height: 32
            verticalAlignment: Text.AlignVCenter
            text: spotifyIsland.spotifyMeta
            color: "white"
            font.family: "Fira Sans"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        Row {
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                width: 32; height: 32; radius: 6
                visible: spotifyIsland.spotifyStatus !== "stopped"
                color: prevHover.containsMouse ? "#595450" : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "󰒮"
                    color: "white"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
                MouseArea {
                    id: prevHover
                    anchors.fill: parent; hoverEnabled: true
                    onClicked: { if (!prevProcess.running) prevProcess.running = true }
                }
            }

            Rectangle {
                width: 32; height: 32; radius: 6
                color: toggleHover.containsMouse ? "#595450" : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: spotifyIsland.spotifyStatus === "playing" ? "󰏤"
                        : spotifyIsland.spotifyStatus === "paused"  ? "󰐊"
                        : "󰝚"
                    color: "white"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
                MouseArea {
                    id: toggleHover
                    anchors.fill: parent; hoverEnabled: true
                    onClicked: { if (!toggleProcess.running) toggleProcess.running = true }
                }
            }

            Rectangle {
                width: 32; height: 32; radius: 6
                visible: spotifyIsland.spotifyStatus !== "stopped"
                color: nextHover.containsMouse ? "#595450" : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "󰒭"
                    color: "white"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
                MouseArea {
                    id: nextHover
                    anchors.fill: parent; hoverEnabled: true
                    onClicked: { if (!nextProcess.running) nextProcess.running = true }
                }
            }
        }
    }
}
