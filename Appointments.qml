
/*!
 * \file Appointments.qml
 * Implements displaying the dates of exams.
 *
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
import QtQuick.Controls

// Singleton wird in C++ registriert.
import de.edvschuleplattling.KlaTapp.Theme 1.0

Rectangle {
    color: Theme.colorEdvLightBackground

    property ListModel _items: ListModel {}

    property string _desiredType: ""
    property string _desiredItem: ""
    property string _desiredId: ""
    property string _desiredShortcut: ""

    property string _currentType: ""
    property string _currentItem: ""
    property string _currentId: ""
    property string _currentShortcut: ""

    property var _readyCallback: null



    width: parent.width
    height: parent.height

    Rectangle {
        id: _headline
        width: parent.width
        color: Theme.colorEdvPurple
        height: Theme.headerHeight
        Label {
            text: "<b>Prüfungstermine</b>"
            anchors.centerIn: parent
            color: "#ffffff"
            font.pixelSize: Theme.headerPixelSize
        }
    }

    Communicator {
        id: _communicator
    }

    BusyIndicator {
        id: _busyIndicator
        z: 100 // on top of any other item
        anchors.centerIn: parent
        running: false
    }

    ListView {
        id: _listView
        anchors.top: _headline.bottom
        width: parent.width
        height: parent.height - _headline.height - _footer.height
        clip: true

        model: _items
        delegate: Item {
            height: 60 // Adjusted height for the two rows of text

            // use a rectangle as a row background
            Rectangle {
                color: Theme.shadeColor(Theme.colorEdvBackground,46)
                width: _listView.width
                height: 50
            }

            Row {
                spacing: 6
                // Place the CalendarIcon on the left
                CalendarIcon {
                    month: datum.split(".")[1]
                    day: datum.split(".")[0]
                }

                // First is the course
                Column {
                    width: parent.width /3.5
                    Row {
                        Text {
                            height: 50
                            verticalAlignment: Text.AlignVCenter
                            text: fach
                            font.pixelSize: Theme.dp(20)
                        }
                    }
                }

                // Followed by the kind
                Column {
                    width: parent.width / 7
                    Row {
                        Text {
                            height: 50
                            verticalAlignment: Text.AlignVCenter
                            text: art
                            font.pixelSize: Theme.dp(20)
                        }
                    }
                }

                // time from-to
                Column {
                    width: parent.width / 6
                    Row {
                        height: 18
                        Text {
                            id: _line1
                            text: vonTime
                            font.pixelSize: Theme.dp(18)
                        }
                    }
                    Row {
                        height: 10
                        Text {
                            text: "-"
                            width: _line1.width
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: Theme.dp(10)
                        }
                    }
                    Row {
                        height: 18
                        Text {
                            text: bisTime
                            font.pixelSize: Theme.dp(18)
                        }
                    }
                }

                // On the right, depending on the mode: teacher, class, room
                Column {
                    width: parent.width / 6
                    Row { // dummy row as placeholder
                        Text {
                            height: 5
                            text: "  "
                        }
                    }
                    Row {
                        spacing: 20
                        Text {
                            text: (_currentType !== "room"
                                   ? "   Raum: " + raum
                                   : (_currentType === "course"
                                        ? "   Lehrer: " + lehrer
                                        : "   Klasse: " + klasse))
                            font.pixelSize: Theme.dp(18)
                        }
                    }
                    Row {
                        Text {
                            text: (_currentType !== "teacher"
                                   ? "   Lehrer: " + lehrer
                                   : (_currentType === "course"
                                        ? "   Raum: " + raum
                                        : "   Klasse: " + klasse))
                            font.pixelSize: Theme.dp(18)
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id: _footer
        width: parent.width; height: Theme.footerHeight
        anchors {  bottom: parent.bottom }
        color: Theme.colorEdvBackground
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Calls webservice for the desired appointments
     */
    function loadAppointments(type, item, id, shortcut, callback)
    {
        console.log("Lade Appointments...")
        var url = "/?Request=Examdates"
        // if(type === _currentType && id === _currentId &&
        //         item === _currentItem && shortcut === _currentShortcut) {
        //     return
        // }
        console.log("Lade Appointments..." + url)

        _desiredType = type
        _desiredItem = item
        _desiredId = id
        _desiredShortcut = shortcut

        url += "&Variant="
        switch(_desiredType)
        {
        case "course": url += "c&Key=" + id;
            break;
        case "teacher": url += "t&Key=" + id //shortcut.toLowerCase();
            // bei Lehrern braucht man das Kuerzel, weil die DB2 die
            // IDs nicht kennt.
            break;
        case "room": url += "r&Key=" + id;
            break;
        default:
            //busyIndicator.running = false
            return;
        }
        _readyCallback = callback
        _busyIndicator.running = true
        _communicator.httpRequest(url,appointmentCallback)
        console.log("AppointmentsUrl: " + url);
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Callback, notifying when appointments are arrived
     */
    function appointmentCallback(json, ok)
    {
        _busyIndicator.running = false
        if(ok === true) {
            _items.clear()
            for(var i = 0; i < json.length; i++) {
                var klasse = json[i]["classAlias"]
                // Klassen abkürzen, damit der Platz ausreicht
                klasse = klasse.replace("BFS","")
                klasse = klasse.replace("FS","F")
                _items.append( {  "fach" : json[i]["courseShort"] ,
                                  "datum" : json[i]["examDate"],
                                  "klasse" : klasse,
                                  "art" : json[i]["kindShort"],
                                  "raum" : json[i]["roomNo"],
                                  "lehrer" : json[i]["teacherShort"],
                                  "von" : json[i]["hourFrom"],
                                  "bis" : json[i]["hourTo"],
                                  "vonTime" : json[i]["timeFrom"],
                                  "bisTime" : json[i]["timeTo"] } )
            }
            _currentType = _desiredType
            _currentItem = _desiredItem
            _currentId = _desiredId
            _currentShortcut = _desiredShortcut
        }
        _readyCallback(ok,_currentItem)
        console.log("Appointments fertig")
    }

}  // End component
