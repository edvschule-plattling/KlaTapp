/*!
 * \file main.qml
 *
 *  Main window of KlaTapp.
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

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

// Google-Icons
//https://www.google.com/design/icons

// Singleton wird in C++ registriert.
import de.edvschuleplattling.KlaTapp.Theme 1.0
import de.edvschuleplattling.KlaTapp.Config 1.0



ApplicationWindow {
    title: qsTr("KlaTapp")
    id: _window
    width: 320
    height: 544 //480 Seitenverhältnis wie am Handy
    visible: true

    property alias scheduleItem: _scheduleTab.item
    property alias appointmentsItem: _appointmentsTab.item
    property alias settingsItem: _settingsTab.item

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
        width: parent.width; height: parent.height / 15
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
    Image {
        id: _logo
        source: "pics/KlaTapp100.png"
        anchors { verticalCenter: headLine.verticalCenter }
        height: headLine.height * 0.9
        fillMode: Image.PreserveAspectFit
    }

    // School logo
    Image {
        source: "pics/edvlogo200.png"
        anchors { left: _logo.right; right: _modeText.left }
        height: headLine.height // * 0.9
        fillMode: Image.PreserveAspectFit
    }

    // TabView with different pages
    TabView {
        id: _tabView;
        anchors { fill: parent; bottomMargin: 10; topMargin: headLine.height; }
        tabPosition: Qt.BottomEdge

        style: TabViewStyle {
                frameOverlap: 1
                tab: Rectangle {
                    color: styleData.selected ? Theme.colorEdvBackground
                                              : Theme.colorEdvLightBackground
                    implicitWidth: _tabView.width / 4
                    implicitHeight: 20
                    height: headLine.height
                    radius: 2
                    Text {
                        id: text
                        anchors.centerIn: parent
                        text: ""
                        color: styleData.selected ? "white" : "black"
                        font.pixelSize: Theme.dp(20)
                    }
                    Image {
                        source: styleData.title
                        anchors { fill: parent }
                        fillMode: Image.PreserveAspectFit
                    }
                }
        }

        // Stundenplan
        Tab {
            id: _scheduleTab
            title: _tabView.currentIndex === 0
                   ? "pics/ic_view_comfy_white_24dp.png"
                   : "pics/ic_view_comfy_black_24dp.png"
            Schedule {
                // Diese id ist leider nicht im Scope.
                // Tabs werden irgendwie dynamisch nachgeladen.
                // Deshalb die Sache mit dem property-alias
                // Siehe auch Kommentar bei der Verwendung!
                //id: mySchedule
            }

        }  // End Stundenplan

        // Prüfungstermine
        Tab {
            id: _appointmentsTab
            title: _tabView.currentIndex === 1
                   ? "pics/ic_flash_on_white_24dp.png"
                   : "pics/ic_flash_on_black_24dp.png"
            //property Item myAp: item.myAppointments
            Appointments {
            }
        }  // End Pruefungstermine

        // Raumsuche
        Tab {
            id: _roomsearchTab
            title: _tabView.currentIndex === 2
                   ? "pics/ic_zoom_in_white_24dp.png"
                   : "pics/ic_zoom_in_black_24dp.png"
            //property Item myAp: item.myAppointments
            RoomSearch {
            }
        }  // End Raumsuche

        // Einstellungen
        Tab {
            id: _settingsTab
            title: _tabView.currentIndex === 3
                   ? "pics/ic_build_white_24dp.png"
                   : "pics/ic_build_black_24dp.png"
            Settings {
                id: _settings
                // Parameter type (Klasse, Raum, Lehrer) , item, id des Items
                onSelectionChanged: {
                    //_modeText.text = "-";
                    console.log("Id des gewählten Items",id)
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

    }  // TabView

    Component.onCompleted: {
        // Es ist erst der erste Tab verfügbar. Die beiden im Hintergrund
        // sind noch null
        //console.log(_tabView.getTab(1).item)

        // Test, on die Verbindung zum Server klappt
        //_busyIndicator.running = true

        _communicator.tryLogin(loginCallback)

        // console.log("SETTINGS:",Config.displayType,
        //                         Config.displayItem,
        //                         Config.displayId,
        //                         Config.displayShortcut)
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
        scheduleItem.loadSchedule(desireType,desireItem,desireId,
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
        appointmentsItem.loadAppointments(desireType,desireItem,desireId,
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

