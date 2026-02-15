/*!
 * \file Toast.qml
 *
 *  Message like Android toast.
 */
/*
 *  This file is part of KlaTapp.
 *  Copyright 2015-2026 EDV-Schule Plattling <www.edvschule-plattling.de>.
 *
 *  KlaTapp is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  KlaTapp is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with KlaTapp.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick
Loader {
    id: _messages

    function displayMessage(message) {
        _messages.source = "";
        _messages.source = Qt.resolvedUrl("ToastComponent.qml");
        _messages.item.message = message;
    }

    width: parent.width
    anchors.bottom: parent.top
    anchors.bottomMargin: 150 // damit es am Ende wieder ganz nach oben verschwindet
    z: 1
    onLoaded: {
        _messages.item.state = "portrait";
        timer.running = true
        _messages.state = "show"
    }

    Timer {
        id: timer

        interval: 2500
        onTriggered: {
            _messages.state = ""
        }
    }

    states: [
        State {
            name: "show"
            AnchorChanges { target: _messages; anchors { bottom: undefined; top: parent.top } }
            PropertyChanges { target: _messages; anchors.topMargin: 100 }
        }
    ]

    transitions: Transition {
        AnchorAnimation { easing.type: Easing.OutQuart; duration: 300 }
    }
}
