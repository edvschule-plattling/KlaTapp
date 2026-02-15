/*!
 * \file ToastComponent.qml
 *
 *  Component for the Toast.
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

Item {
    id: _banner

    property alias message : _messageText.text

    height: 70

    Rectangle {
        id: _background

        anchors.fill: _banner
        color: Theme.colorEdvDarkBackground
        smooth: true
        opacity: 0.8
    }

    Text {
        font.pixelSize: 24
        width: 150
        height: 40
        id: _messageText
        anchors.fill: _banner
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        color: "white"
    }

    states: State {
        name: "portrait"
        PropertyChanges { target: _banner; height: 100 }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            _messages.state = ""
        }
    }
}
