import QtQuick
import Quickshell.Services.Pipewire

Rectangle {
    id: volIsland
    color: "#212121"
    radius: 10
    height: parent.height
    implicitWidth: volIslandRow.implicitWidth + 24

    readonly property real vol: Pipewire.defaultAudioSink?.audio.volume ?? 0
    readonly property bool isMuted: Pipewire.defaultAudioSink?.audio.muted ?? false
    readonly property bool hovered: volHover.hovered

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Rectangle {
        anchors { fill: parent; margins: 4 }
        radius: 6
        color: volHover.hovered ? "#595450" : "transparent"

        HoverHandler { id: volHover }

        MouseArea {
            anchors.fill: parent
            onWheel: event => {
                var audio = Pipewire.defaultAudioSink?.audio
                if (audio) {
                    var delta = event.angleDelta.y > 0 ? 0.05 : -0.05
                    audio.volume = Math.max(0, Math.min(1.5, audio.volume + delta))
                }
            }
            onClicked: {
                var audio = Pipewire.defaultAudioSink?.audio
                if (audio) audio.muted = !audio.muted
            }
        }

        Row {
            id: volIslandRow
            anchors.centerIn: parent
            spacing: 8

            Text {
                height: 32
                verticalAlignment: Text.AlignVCenter
                text: {
                    if (volIsland.isMuted) return "󰖁"
                    if (volIsland.vol < 0.33) return "󰕿"
                    if (volIsland.vol < 0.66) return "󰖀"
                    return "󰕾"
                }
                color: "white"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 16
                font.weight: Font.DemiBold
            }

            Item {
                width: 80; height: 32

                Rectangle {
                    width: parent.width
                    height: 6
                    radius: 3
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#404040"

                    Rectangle {
                        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                        width: parent.width * Math.min(1, volIsland.isMuted ? 0 : volIsland.vol)
                        radius: parent.radius
                        color: "white"

                        Behavior on width {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }
                    }
                }
            }
        }
    }
}
