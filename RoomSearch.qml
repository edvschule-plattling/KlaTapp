/*!
 * \file RoomSearch.qml
 *
 * Allows to search for a free room at a certain time.
 * tbd.
 */
/*
 * This file is part of KlaTapp.
 * Copyright 2015-2026 EDV-Schule Plattling <www.edvschule-plattling.de>.
 *
 * KlaTapp is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * KlaTapp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with KlaTapp. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import de.edvschuleplattling.KlaTapp.Theme 1.0

Rectangle {
    id: _root
    color: Theme.colorEdvLightBackground
    width: parent.width
    height: parent.height

    ListModel {
        id: _dateModel
    }

    BusyIndicator {
        id: _busyIndicator
        z: 100 // on top of any other item
        anchors.centerIn: parent
        running: false
    }

    Rectangle {
        id: _headLine
        width: parent.width
        height: Theme.headerHeight
        color: Theme.colorEdvPurple
        Label {
            text: "<b>Raumsuche</b>"
            anchors.centerIn: parent
            color: "#ffffff"
            font.pixelSize: Theme.headerPixelSize
        }
    }

    GridLayout {
        id: _grid
        columns: 5
        rows: 3
        rowSpacing: Theme.dp(10)
        anchors { top: _headLine.bottom; topMargin: 10 + Theme.dp(12);
            left: parent.left; right: parent.right}

        Rectangle {
            id: _navigationBar
            Layout.column: 0
            Layout.columnSpan: 5
            Layout.row: 0
            Layout.minimumHeight: Theme.headerHeight
            Layout.fillWidth: true
            Layout.rightMargin: Theme.dp(10)
            Layout.leftMargin: Theme.dp(10)
            color: Theme.colorEdvBackground

            ListView {
                id: _dateListView
                property int delegateWidth: width / 1.5
                anchors.fill: parent
                orientation: ListView.Horizontal
                clip: true
                snapMode: ListView.SnapOneItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: ((width - delegateWidth) / 2)
                preferredHighlightEnd: preferredHighlightBegin + delegateWidth
                highlightMoveDuration: Theme.dp(400)

                model: _dateModel

                delegate: Item {
                    id: _dateItemDelegate

                    width: ListView.view.delegateWidth
                    height: ListView.view.height

                    Item {
                        width: parent.width
                        height: _navigationBar.height
                        Label {
                            anchors.centerIn: parent
                            text: day + ", " + date.toLocaleString(Qt.locale(),"dd.M.yyyy")
                            color: "#ffffff"
                            font.pixelSize: Theme.headerPixelSize
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: _dateItemDelegate.ListView.view.currentIndex = index
                    }
                }
            }
        }

        RangeSlider {
            id: _slider
            from: 1
            to: 13
            first.value: 1
            second.value: 2
            stepSize: 1
            snapMode: Slider.SnapAlways
            Layout.column: 0
            Layout.columnSpan: 5
            Layout.row: 1
            Layout.leftMargin: Theme.dp(10)
            Layout.rightMargin: Theme.dp(10)
            Layout.minimumWidth: (4 * _root.width / 4) - 2 * Theme.dp(10)
            Layout.minimumHeight: Theme.dp(50)

            first.onMoved: {
                _fromLabel.text = makeTimeFromValue(first.value, "start")
            }

            second.onMoved: {
                if (_toLabel) {
                    _toLabel.text = makeTimeFromValue(second.value, "end")
                }
            }
        }

        Label {
            id: _fromLabel
            text: "08:00"
            font.pixelSize: Theme.headerPixelSize
            Layout.column: 1
            Layout.row: 2
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Theme.dp(10)
        }
        Label {
            id: _toLabel
            text: "08:45"
            font.pixelSize: Theme.headerPixelSize
            Layout.column: 3
            Layout.row: 2
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Theme.dp(10)
        }
    }  // End of GridLayout

    Button {
        id: _searchButton
        height: Theme.dp(50)
        width: Theme.dp(50)
        anchors { top: _grid.bottom; horizontalCenter: _grid.horizontalCenter;
            topMargin: Theme.dp(10) }

        background: Rectangle {
            Image {
                source: "pics/search_black.svg"
                anchors { fill: parent }
                height: Theme.dp(30)
                fillMode: Image.Pad
            }
            anchors { fill: parent }
            height: Theme.dp(30)
            border.color: Theme.colorEdvPurple
            color: _searchButton.pressed ? Theme.colorEdvPurple
                                          : Theme.colorEdvLightBackground
        }

        onClicked: {
            var currentDate = _dateModel.get(_dateListView.currentIndex).date;
            var formattedDate = currentDate.getFullYear() + '-' +
                                ('0' + (currentDate.getMonth() + 1)).slice(-2) + '-' +
                                ('0' + currentDate.getDate()).slice(-2);

            loadFreeRooms(formattedDate, _slider.first.value, _slider.second.value);
        }
    }

    Flow {
        id: _roomListLayout
        anchors { top: _searchButton.bottom; topMargin: Theme.dp(20);
                  horizontalCenter: _grid.horizontalCenter }
        width: parent.width

        Repeater {
            anchors.margins: 40
            id: _roomRepeater
            model: _availableRoomsModel // Define this ListModel or use your own data source

            delegate: Rectangle {
                width: Theme.dp(50)  // Adjust width as needed
                height: Theme.dp(50) // Adjust height as needed
                color: "lightblue"
                border.color: "blue"
                border.width: 1
                radius: Theme.dp(4)


                Text {
                    anchors.centerIn: parent
                    text: modelData
                    color: "black"
                    font.pixelSize: Theme.dp(16)
                }
            }
        }
    }

    Rectangle {
        id: _footer
        width: parent.width;
        height: Theme.footerHeight
        anchors { bottom: parent.bottom }
        color: Theme.colorEdvBackground
    }

    Component.onCompleted: {
        // Initialize date model for 14 days starting from today
        var today = new Date();
        var daynames = [ "Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag",
                         "Freitag", "Samstag" ];

        for (var i = 0; i < 14; i++) {
            _dateModel.append({ "day": "<b>" + daynames[today.getDay()] + "</b>",
                                "date": new Date(today) }); // Copy date to prevent reference issues
            today.setDate(today.getDate() + 1);
        }
    }

    // Converts the slider value to a time.
        function makeTimeFromValue(value, type) {
            let valueR = Math.round(value)
            var timeIntervals = [
                { 'start': '08:00', 'end': '08:45' },
                { 'start': '08:45', 'end': '09:30' },
                { 'start': '09:45', 'end': '10:30' },
                { 'start': '10:30', 'end': '11:15' },
                { 'start': '11:30', 'end': '12:15' },
                { 'start': '12:15', 'end': '13:00' },
                { 'start': '13:00', 'end': '13:45' },
                { 'start': '13:45', 'end': '14:30' },
                { 'start': '14:45', 'end': '15:30' },
                { 'start': '15:30', 'end': '16:15' },
                { 'start': '16:15', 'end': '17:00' },
                { 'start': '17:00', 'end': '17:45' },
                { 'start': '17:45', 'end': '18:30' },
            ];

            if (valueR <= timeIntervals.length){
                return timeIntervals[valueR-1][type]
            }

            // Default return if no match found (should not normally happen with correct setup)
            return "00:00";
        }

    // Calls webservice for the free rooms
    function loadFreeRooms(date, from, until) {
        _busyIndicator.running = true;
        console.log("Loading free rooms...");
        var url = "?Request=FreeRooms";
        url += "&date=" + date;
        url += "&from=" + Math.round(from);
        url += "&until=" + Math.round(until);

        _communicator.httpRequest(url, freeRoomsCallback);
    }

    // Callback, notifying when free rooms are arrived
    function freeRoomsCallback(json, ok) {
        if (ok === true) {
            // Process the JSON data to update UI or handle accordingly
            console.log("FreeRooms response:", json);

            // Assuming `json` is an array of room IDs or names
            var availableRooms = json;

            // Clear previous data
            _availableRoomsModel.clear();

            // Populate the model with new data
            for (var i = 0; i < availableRooms.length; ++i) {
                _availableRoomsModel.append({ "roomName": availableRooms[i] });
            }
        } else {
            console.error("Failed to load free rooms.");
            // Handle error scenario
        }
        _busyIndicator.running = false;
    }

    // Define a ListModel for available rooms if not using an existing one
    ListModel {
        id: _availableRoomsModel // This model stores available room data
    }
}
