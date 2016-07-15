/*!
 * \file Appointments.qml
 * Implements displaying the dates of exams.
 *
 */
/*
 *  This file is part of KlaTapp.
 *  Copyright 2015-2016 EDV-Schule Plattling <www.edvschule-plattling.de>.
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

import QtQuick 2.0
import QtQuick.Controls 1.4

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
        anchors.centerIn: parent
        running: false
    }

    ListView {
        id: _listView;
        anchors.top: _headline.bottom
        width: parent.width; height: parent.height - _headline.height - _footer.height
        clip: true

        model: _items
        delegate:
            Item {
                height: Theme.dp(20) * 1.5
                Row {

                    Text {
                        text: datum;
                        width: _listView.width/4;
                        font.pixelSize: Theme.dp(20)
                    }
                    Text {
                        text: fach ;
                        width: _listView.width/5;
                        font.pixelSize: Theme.dp(20)
                    }
                    Text {
                        text: art ;
                        width: _listView.width/7;
                        font.pixelSize: Theme.dp(20)
                    }
                    // hier kommen ab und zu zwei Fehler
                    //qrc:/Appointments.qml:65:39: Unable to assign [undefined] to QString
                    //qrc:/Appointments.qml:60:39: Unable to assign [undefined] to QString
                    Text {
                        text: (_currentType !== "room"
                                  ? raum
                                  : (_currentType === "course" ? lehrer
                                                               : klasse));
                        width: _listView.width/6;
                        font.pixelSize: Theme.dp(20)
                    }
                    Text {
                        text: (_currentType !== "teacher"
                                  ? lehrer
                                  : (_currentType === "course" ? raum
                                                               : klasse));
                        width: _listView.width/6;
                        font.pixelSize: Theme.dp(20)
                    }
                    Text {
                        text: von + "-" + bis ;
                        width: _listView.width/6;
                        font.pixelSize: Theme.dp(20)
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
        var url = "/KlaTabService.php?SearchNach=Termin"
        if(type === _currentType && id === _currentId &&
           item === _currentItem && shortcut === _currentShortcut) {
            return
        }

        _desiredType = type
        _desiredItem = item
        _desiredId = id
        _desiredShortcut = shortcut

        switch(_desiredType)
        {
            case "course": url += "&Klasse=" + id;
                break;
            case "teacher": url += "&Lehrer=" + shortcut.toLowerCase();
                // bei Lehrern braucht man das Kuerzel, weil die DB2 die
                // IDs nicht kennt.
                break;
            case "room": url += "&Raum=" + id;
                break;
            default:
                //busyIndicator.running = false
                return;
        }
        _readyCallback = callback
        _busyIndicator.running = true
        _communicator.httpRequest(url,appointmentCallback)
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
                var klasse = json[i]["klasse"]
                // Klassen abkürzen, damit der Platz ausreicht
                klasse = klasse.replace("BFS","")
                klasse = klasse.replace("FS","F")
                _items.append( {  "fach" : json[i]["fach"] ,
                                  "datum" : json[i]["datum"],
                                  "klasse" : klasse,
                                  "art" : json[i]["art"],
                                  "raum" : json[i]["raum"],
                                  "lehrer" : json[i]["lehrer"],
                                  "von" : json[i]["von"],
                                  "bis" : json[i]["bis"] } )
            }
            _currentType = _desiredType
            _currentItem = _desiredItem
            _currentId = _desiredId
            _currentShortcut = _desiredShortcut
        }
        _readyCallback(ok,_currentItem)
    }

}  // End component

