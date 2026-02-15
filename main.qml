/*!
 * \file main.qml
 *
 *  Main window of KlaTapp.
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
import QtQuick.Layouts
//import QtQuick.Controls.Material
import QtQuick.Window
import QtQuick.Dialogs

// Google-Icons
//https://www.google.com/design/icons

// Singleton wird in C++ registriert.
import de.edvschuleplattling.KlaTapp.Theme 1.0
import de.edvschuleplattling.KlaTapp.Config 1.0




ApplicationWindow {
    title: qsTr("KlaTapp")
    id: _window
    width: 380
    height: 720
    visible: true
    //Material.theme: Material.LightBlue

    property alias scheduleItem: _scheduleTab
    property alias appointmentsItem: _appointmentsTab
    property alias settingsItem: _settingsTab

    property string displayType: ""
    property string displayItem: ""
    property string displayId: ""
    property string displayShortcut: ""

    property string desireType: Config.displayType
    property string desireItem: Config.displayItem
    property string desireId: Config.displayId
    property string desireShortcut: Config.displayShortcut

    Toast {
        id: _toast
    }

    Communicator {
        id: _communicator
    }

    // Headline with Image and Background
    Rectangle {
        id: headLine
        width: parent.width; height: parent.height / 10
        anchors { top: parent.top;  }
        color: Theme.colorEdvBackground
    }

    // Display currently shown item-identifier
    Text {
        id: _modeText
        anchors { right: parent.right;
            rightMargin: 5;
            verticalCenter: headLine.verticalCenter  }
        text: "-"
    }

    // KlaTapp logo
       // Image {
       //     id: _logo
       //     source: "pics/KlaTapp100.png"
       //     anchors { verticalCenter: headLine.verticalCenter }
       //     height: headLine.height * 0.9
       //     fillMode: Image.PreserveAspectFit
       // }

    // School logo
    Image {
        source: "pics/logoEDVSchule300.png"
        anchors { left: parent.left; leftMargin: 5 }
        height: headLine.height * 0.9
        fillMode: Image.PreserveAspectFit
    }

    // TabView with different pages
    TabBar {
        id: _tabView;
        width: parent.width
        anchors {
            bottom: parent.bottom
        }
        height: 45

        TabButton {
            height: parent.height
            background: Rectangle {
                color: _tabView.currentIndex === 0 ? Theme.colorEdvBackground
                                                   : Theme.colorEdvLightBackground
            }
            anchors { bottom: parent.bottom }
            Image{
                source: _tabView.currentIndex === 0
                        ? "pics/schedule_white.svg"
                        : "pics/schedule_black.svg"
                width: parent.width
                height: 30
                horizontalAlignment: Image.AlignHCenter
                fillMode: Image.Pad
            }
            Text {
               text: "Stundenplan"
               width: parent.width
               anchors.bottom: parent.bottom
               horizontalAlignment: Text.AlignHCenter
            }
        }
        TabButton {
            height: parent.height
            background: Rectangle {
                color: _tabView.currentIndex === 1 ? Theme.colorEdvBackground
                                                   : Theme.colorEdvLightBackground
            }
            anchors { bottom: parent.bottom }
            Image{
                source: _tabView.currentIndex === 1
                        ? "pics/flash_white.svg"
                        : "pics/flash_black.svg"
                width: parent.width
                height: 30
                horizontalAlignment: Image.AlignHCenter
                fillMode: Image.Pad
            }
            Text {
               text: "Prüfungen"
               width: parent.width
               anchors.bottom: parent.bottom
               horizontalAlignment: Text.AlignHCenter
            }
        }
        TabButton {
            height: parent.height
            background: Rectangle {
                color: _tabView.currentIndex === 2 ? Theme.colorEdvBackground
                                                   : Theme.colorEdvLightBackground
            }
            anchors { bottom: parent.bottom }
            Image{
                source: _tabView.currentIndex === 2
                        ? "pics/search_white.svg"
                        : "pics/search_black.svg"
                width: parent.width
                height: 30
                horizontalAlignment: Image.AlignHCenter
                fillMode: Image.Pad
            }
            Text {
               text: "Raumsuche"
               width: parent.width
               anchors.bottom: parent.bottom
               horizontalAlignment: Text.AlignHCenter
            }
        }
        TabButton {
            height: parent.height
            background: Rectangle {
                color: _tabView.currentIndex === 3 ? Theme.colorEdvBackground
                                                   : Theme.colorEdvLightBackground
            }
            anchors { bottom: parent.bottom }
            Image{
                source: _tabView.currentIndex === 3
                        ? "pics/build_white.svg"
                        : "pics/build_black.svg"
                width: parent.width
                height: 30
                horizontalAlignment: Image.AlignHCenter
                fillMode: Image.Pad
            }
            Text {
               text: "Einstellungen"
               width: parent.width
               anchors.bottom: parent.bottom
               horizontalAlignment: Text.AlignHCenter
            }
        }

        onCurrentIndexChanged: {
            if(currentIndex === 0) {
                loadSchedule()
            }
            else if(currentIndex === 1) {
                loadAppointments()
            }
            else if(currentIndex === 3) {
                initSettings()
            }
        }

    }

    StackLayout {
        width: parent.width
        height: parent.height - headLine.height - _tabView.height // Adjust height to fit content
        currentIndex: _tabView.currentIndex
        anchors {
            bottom: _tabView.top
            topMargin: headLine.height;
        }
        // Stundenplan
        Item {
            id: _scheduleTab

            Schedule {
                // Diese id ist leider nicht im Scope.
                // Tabs werden irgendwie dynamisch nachgeladen.
                // Deshalb die Sache mit dem property-alias
                // Siehe auch Kommentar bei der Verwendung!
                // id: mySchedule
            }

        }  // End Stundenplan

        // Prüfungstermine
        Item {
            id: _appointmentsTab
            Appointments {
            }
        }  // End Pruefungstermine

        // Raumsuche
        Item {
            id: _roomsearchTab
            RoomSearch {
            }
        }  // End Raumsuche

        // Einstellungen
        Item {
            id: _settingsTab
            SettingsPage {
                id: _settings
                // Parameter type (Klasse, Raum, Lehrer) , item, id des Items
                onSelectionChanged: function(type, item, id, shortcut) {
                    //_modeText.text = "-";
                    console.log("Neuer Filter:", type, item, id, shortcut)
                    // Leider kann man die id der Stundenplan-Komponente nicht
                    // verwenden. Deshalb entweder über den Index und das Item,
                    // oder über ein entsprechendes Property zugreifen, um die
                    // Funktion aus der Komponente aufrufen zu können.
                    // Variante 1
                    //   var tab = _tabView.getTab(0)
                    //   tab.item.querySchedule()
                    // Variante 2
                    //loadSchedule(type, id, item)
                    desireType = type
                    desireItem = item
                    desireId = id
                    desireShortcut = shortcut
                }

            }
        }  // End Einstellungen
    }



    Component.onCompleted: {
        // Es ist erst der erste Tab verfügbar. Die beiden im Hintergrund
        // sind noch null
        //console.log(_tabView.getTab(1).item)

        // Test, on die Verbindung zum Server klappt
        //_busyIndicator.running = true

        _communicator.tryLogin(loginCallback)

        console.log("SETTINGS:",Config.displayType,
                                Config.displayItem,
                                Config.displayId,
                                Config.displayShortcut)
    }

    Component.onDestruction: {
    }


    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Called by the communicator after trying to log in to the server
     */
    function loginCallback(ok)
    {
        //_busyIndicator.running = false
        if(ok === true) {
            loadSchedule()
        }
        else {
            _toast.displayMessage("Login fehlgeschlagen")
            _tabView.currentIndex = 3
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Function to start loading the desired schedule via the communicator
     */
    function loadSchedule()
    {
        //_busyIndicator.running = true
        scheduleItem.children[0].loadSchedule(desireType,desireItem,desireId,
                                              desireShortcut, scheduleCallback)
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Called by communicator after schedule is loaded
     *  \param ok true on success, else false
     *  \value item/id to display the loaded item
     */
    function scheduleCallback(ok,value)
    {
        //_busyIndicator.running = false
        _modeText.text = value
        if(ok === true) {
            displayType = desireType
            displayItem = desireItem
            displayId = desireId
            displayShortcut = desireShortcut
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Function to start loading the desired appointments via the communicator
     */
    function loadAppointments()
    {
        appointmentsItem.children[0].loadAppointments(desireType,desireItem,desireId,
                                                      desireShortcut, appointmentCallback)
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Called by communicator after appointments are loaded
     *  \param ok true on success, else false
     *  \value item/id to display the loaded item
     */
    function appointmentCallback(ok,value)
    {
        _modeText.text = value
        if(ok === true) {
            displayType = desireType
            displayItem = desireItem
            displayId = desireId
            displayShortcut = desireShortcut
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Sets default settings: Currently no effect at all
     */
    function initSettings()
    {
        // Aus den bekannten Gründen geht es nur über den Index.
        //_tabView.getTab(3).item.setDefaults()
    }

}
