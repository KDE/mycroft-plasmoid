import QtQuick 2.9
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    anchors.fill: parent

    Rectangle {
         id: innerCircleSurround
         anchors.centerIn: parent
         color: "#404682b4"
         border.color: "#00000000"
         border.width: units.gridUnit * 0.2
         radius: 100
         implicitWidth: units.gridUnit * 2.7
         implicitHeight: units.gridUnit * 2.7
        }

    Rectangle {
         id: innerCircleSurroundOutterRing
         anchors.centerIn: parent
         color: "#00000000"
         border.color: "lightblue"
         border.width: units.gridUnit * 0.2
         radius: 100
         implicitWidth: units.gridUnit * 2.7
         implicitHeight: units.gridUnit * 2.7
        }

    Rectangle {
         id: innerCircleIn
         anchors.centerIn: parent
         color: "lightblue"
         border.color: "steelblue"
         border.width: units.gridUnit * 0.1
         radius: 100
         implicitWidth: units.gridUnit * 1.7
         implicitHeight: units.gridUnit * 1.7
        }

    Rectangle {
         id: innerCircleInMic
         anchors.centerIn: parent
         color: "#00000000"
         border.color: "#00000000"
         border.width: units.gridUnit * 0.1
         radius: 100
         implicitWidth: units.gridUnit * 1.7
         implicitHeight: units.gridUnit * 1.7

         PlasmaComponents.ToolButton {
            id: innerImgInnerCirc
            anchors.centerIn: parent
            iconSource: "audio-input-microphone"
            width: units.gridUnit * 2
            height: units.gridUnit * 2
            
            onClicked: {
                var socketmessage = {};
                socketmessage.type = "mycroft.mic.listen";
                socketmessage.data = {};
                socketmessage.data.utterances = [];
                socket.sendTextMessage(JSON.stringify(socketmessage));
                }
            }
        }

    ScaleAnimator {
        target: innerCircleSurround
        running: true
        from: 1.2
        to: 0.8
        duration: 3600
        loops: Animation.Infinite
        }

    ScaleAnimator {
        target: innerCircleSurroundOutterRing
        running: true
        from: 1
        to: 0.9
        duration: 3600
        loops: Animation.Infinite
        }

    ScaleAnimator {
        target: innerCircleIn
        running: true
        from: 0.8
        to: 1
        duration: 3600
        loops: Animation.Infinite
        }
}
