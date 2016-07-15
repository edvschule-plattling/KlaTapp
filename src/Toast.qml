/*!
 * \file Toast.qml
 *
 *  Message like Android toast.
 */
import QtQuick 2.2
Loader {
    id: messages

    function displayMessage(message) {
        messages.source = "";
        messages.source = Qt.resolvedUrl("ToastComponent.qml");
        messages.item.message = message;
    }

    width: parent.width
    anchors.bottom: parent.top
    anchors.bottomMargin: 150 // damit es am Ende wieder ganz nach oben verschwindet
    z: 1
    onLoaded: {
        messages.item.state = "portrait";
        timer.running = true
        messages.state = "show"
    }

    Timer {
        id: timer

        interval: 2500
        onTriggered: {
            messages.state = ""
        }
    }

    states: [
        State {
            name: "show"
            AnchorChanges { target: messages; anchors { bottom: undefined; top: parent.top } }
            PropertyChanges { target: messages; anchors.topMargin: 100 }
        }
    ]

    transitions: Transition {
        AnchorAnimation { easing.type: Easing.OutQuart; duration: 300 }
    }
}
