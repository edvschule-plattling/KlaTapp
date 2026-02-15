/*!
 * \file SettingsPage.qml
 *
 *  Implements the differen configuration parameters
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
import QtQuick.Dialogs

// Singleton wird in C++ registriert.
import de.edvschuleplattling.KlaTapp.Theme 1.0
import de.edvschuleplattling.KlaTapp.Config 1.0

/*!
 * Settings component
 */
Rectangle {
    id: _root
    clip: true
    color: Theme.colorEdvLightBackground
    onVisibleChanged: console.log("VISIBLE CHANGED")
    width: parent.width
    height: parent.height

    property alias user: _inputUser.text
    property alias password : _inputPassword.text

    property ListModel courseItems: ListModel {}
    property ListModel teacherItems: ListModel {}
    property ListModel roomItems: ListModel {}


    // die Properties haben Variant, weil sie von JSon kommen.
    // Wenn man string verwendet, gibt es irgendwo Fehlermeldungen,
    // selbst, wenn man die JSON-Werte mit toString konvertiert.
    // TODO: Sollte man mal untersuchen
    property variant courseIds: [];
    property variant teacherIds: [];
    property variant teacherShortcuts: [];
    property variant roomIds: [];

    Toast {
        id: _toast
    }



    Communicator {
        id: _communicator
    }

    // private properties should reside inside a local QtObject
    QtObject {
        id: d
        property variant type
        property variant id
        property variant item
        property variant shortcut
        property bool connected: false
    }

    signal selectionChanged(string type, string item, string id, string shortcut)

    Rectangle {
        id: _headLine
        width: parent.width
        height: Theme.headerHeight
        color: Theme.colorEdvPurple
        Label {
            text: "<b>Einstellungen</b>"
            anchors.centerIn: parent
            color: "#ffffff"
            font.pixelSize: Theme.headerPixelSize
        }
    }

    ScrollView {
        width: parent.width
        anchors {
            top: _headLine.bottom
            bottom: _footer.top
        }

        Item {
            height: _grid1.height + _text.height
            width: parent.width
            implicitHeight: height
            GridLayout {
                id: _grid1
                columns: 4
                width: parent.width
                rows: 7
                rowSpacing: Theme.dp(8)

                anchors { top: parent.top; //_headLine.bottom;
                    topMargin: 10 + Theme.dp(12);
                    leftMargin: Theme.dp(5);
                    left: parent.left;
                    right: parent.right;
                    rightMargin: Theme.dp(5); }

                Label {
                    text: qsTr("Anzeige")
                    font.pixelSize: Theme.dp(30)
                    Layout.column: 0
                    Layout.columnSpan: 1
                    Layout.row: 0
                }

                Button {
                    id: _saveButton
                    text: "Speichern"
                    icon.source: "pics/save_black.svg"
                    icon.height: 25
                    icon.width: 25
                    //Layout.alignment: Qt.AlignRight
                    Layout.row: 0
                    Layout.column: 1
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.minimumHeight: Theme.dp(50)
                    onClicked: {
                        Config.saveConfig()
                    }
                }

                Rectangle {
                    color: "red"  // Abstandhalter im Layout
                    Layout.row: 2
                    Layout.column: 0

                    height: Theme.dp(10)
                }

                ComboBox {
                    id: _typeBox
                    Layout.row: 1
                    Layout.column: 0
                    Layout.columnSpan: 1
                    Layout.maximumWidth: (_root.width / 3.2)
                    Layout.minimumHeight: Theme.dp(50)
                    model: [ qsTr("Klasse"), qsTr("Lehrer"), qsTr("Raum") ]
                    onActivated: function (index) {
                        console.log("type Activated: ",index)
                        if(index === 1) {
                            _itemBox.model = teacherItems
                        }
                        else if(index === 2) {
                            _itemBox.model = roomItems
                        }
                        else {
                            _itemBox.model = courseItems
                        }

                        emitSelectionChanged(index,_itemBox.currentIndex)
                    }
                }

                ComboBox {
                    id: _itemBox
                    Layout.row: 1
                    Layout.column: 1
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.minimumHeight: Theme.dp(50)
                    onActivated: function(index) {
                        emitSelectionChanged(_typeBox.currentIndex,index)
                    }
                }

                Label {
                    text: qsTr("Verbindung")
                    font.pixelSize: Theme.dp(30)
                    Layout.column: 0
                    Layout.columnSpan: 1
                    Layout.row: 3
                }

                Button {
                    icon.source: d.connected === true
                                    ? "pics/sync_black.svg"
                                    : "pics/syncproblem_black.svg"
                    icon.height: 25
                    icon.width: 25
                    // Icon seems a bit blurry, so we could try Image some day
                    // Image {
                    //   source: d.connected === true
                    //                 ? "pics/sync_black.svg"
                    //                 : "pics/syncproblem_black.svg"
                    //   fillMode: Image.Pad
                    //   verticalAlignment: Image.AlignVCenter
                    // }
                    text: "Login"
                    //Layout.alignment: Qt.AlignRight
                    Layout.column: 1
                    Layout.columnSpan: 3
                    Layout.row: 3
                    Layout.fillWidth: true
                    Layout.minimumHeight: Theme.dp(50)
                    //Layout.minimumWidth: _saveButton.width
                    //Layout.rightMargin: Theme.dp(5)

                    onClicked: {
                        testConnection();
                    }
                }


                // for the moment this field is kept but invisible
                // there are still a few dependencies...
                TextField {
                    id: _inputUrl
                    readOnly: true
                    visible: false
                    Layout.fillWidth: true;
                    placeholderText: qsTr("URL")
                    text: Config.serviceBaseUrl
                    Layout.column: 0
                    Layout.columnSpan: 4
                    Layout.row: 4
                }


                TextField {
                    id: _inputUser
                    Layout.fillWidth: true;
                    placeholderText: qsTr("Benutzername")
                    text: Config.serviceUser
                    Layout.column: 0
                    Layout.columnSpan: 4
                    Layout.row: 5
                    Layout.minimumHeight: Theme.dp(50)
                }


                TextField {
                    id: _inputPassword
                    Layout.fillWidth: true;
                    placeholderText: qsTr("Passwort")
                    text: Config.servicePassword
                    echoMode: TextInput.PasswordEchoOnEdit
                    Layout.column: 0
                    Layout.columnSpan: 4
                    Layout.row: 6
                    Layout.minimumHeight: Theme.dp(50)
                }
            }


            Text {
                id: _text
                anchors {
                    top: _grid1.bottom
                    leftMargin: Theme.dp(10)
                    rightMargin: Theme.dp(10)
                    topMargin: Theme.dp(30)
                    left: parent.left
                    right: parent.right
                }
                height: 170

                linkColor: "#2c3e50"
                text:  "\n\nDieses Programm ist Open Source." +
                       " Der Quellcode ist auf " +
                       //" <a href=\"https://github.com/edvschule-plattling/KlaTapp\">Github</a>. [KlaTapp 1.3.0, 02/26]." +
                       " Github. [KlaTapp 1.3.0, 02/26]." +
                       "<br>Es verwendet Qt unter " +
                       " <a href=\"LGPL\">LGPL</a>- und " +
                       "OpenSSL unter <a href=\"Apache\">Apache</a>-Lizenz [" + sslVersion + "]."   + "<br> <br>" +
                       " <a href=\"http://www.edvschule-plattling.de/CMS/nachrichten/bekanntmachungen/181-datenschutzerklaerung-fuer-apps\">Datenschutzerklärung</a> " +
                       " | " +
                       " <a href=\"http://www.edvschule-plattling.de/CMS/kontakt/impressum\">Impressum</a> " +
                       "<br>" +
                       "<br>&copy; 2015-2026 <a href=\"https://www.edvschule-plattling.de\">EDV-Schule Plattling</a> "


                horizontalAlignment: Text.AlignJustify

                onLinkActivated: (link) => linkClicked(link)

                font {
                    weight: Font.Light
                }

                wrapMode: Text.Wrap

            }
        }
    }

    Rectangle {
        id: _footer
        width: parent.width;
        height: Theme.footerHeight
        anchors {  bottom: parent.bottom }
        //color: Theme.colorEdvPurple
        color: Theme.colorEdvBackground
    }

    MessageDialog {
        id: _lgplDialog
        visible: false
        title: "LGPL v3"
        text: lgpltext
    }

    MessageDialog {
        id: _apacheDialog
        visible: false
        title: "Apache v2"
        text: apachetext
    }

    Component.onCompleted: {
        querySelectionData()
    }


    /////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Starts getting the selection data from the server
     */
    function querySelectionData()
    {
        console.log("QuerySelectionData")
        d.connected = false

        // https klappt hier nicht. In C++ schon
        // Mit dem NetworkAccessManager geht es nun
        // siehe http://talk.maemo.org/showthread.php?t=70074
        var url = "/?Request=Basedata"
        _communicator.httpRequest(url,parseSelectionData)

    }

    /////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Callback that uses the delivered selection data
     */
    function parseSelectionData(json,ok)
    {
        if(ok === false) {
            // ohne Verbindung geht nix
            return
        }
        d.connected = true

        // Altes Zeug erst hier löschen, wenn das neue
        // da ist
        courseItems.clear()
        teacherItems.clear()
        roomItems.clear()
        courseIds = []
        teacherIds = []
        teacherShortcuts = []
        roomIds = []

        // Das Array enthält der Reihe nach
        // - Array mit den Klassen
        // - Array mit den Räumen
        // - Array mit den Lehrern

        // TODO
        // Wenn was mit dem Netz nicht passt,
        // dann bräuchte man einen "Retry"-Knopf

        var obj = json
        if(typeof(obj) != 'object') {
            // da ist was faul
            return
        }

        var savedCourseIndex = 0
        var savedTeacherIndex = 0
        var savedRoomIndex = 0

        // Klassen rausholen
        var courses = obj.classes
        for(var i = 0; i < courses.length; i++) {
            //console.log(courses[i]["iId"], courses[i]["sBezeichnung"],courses[i]["Alias"]);
            courseItems.append({"text": courses[i]["classAlias"] /*, "id":courses[i]["iId"]*/ })
            // ^ gibt ReferenceError
            // aber man könnte zugreifen
            courseIds[i] = courses[i]["className"].toString()

            if(Config.displayType === "course" && Config.displayId === courseIds[i]) {
                savedCourseIndex = i                             //^ Achtung Typ
            }
        }

        // Räume rausholen
        var rooms = obj.rooms
        for(i = 0; i < rooms.length; i++) {
            //console.log(rooms[i]["roomNo"]);
            roomItems.append({"text": rooms[i]["roomNo"]})
            roomIds[i] = rooms[i]["roomNo"].toString()
            if(Config.displayType === "room" && Config.displayId === roomIds[i]) {
                savedRoomIndex = i                              //^ Achtung Typ
            }
        }

        // Lehrer rausholen
        var teachers = obj.teachers
        for(i = 0; i < teachers.length; i++) {
            //console.log(teachers[i]["iId"]);
            teacherItems.append({"text": teachers[i]["teacherName"]})
            teacherIds[i] = teachers[i]["id"].toString()
            teacherShortcuts[i] = teachers[i]["teacherShort"].toString()
            if(Config.displayType === "teacher" && Config.displayId === teacherIds[i]) {
                savedTeacherIndex = i                              //^ Achtung Typ
            }
        }

        // Am Ende die Auswahl aus der gespeicherten Config einstellen
        // Klasse / Lehrer / Raum
        if(Config.displayType === "course") {
            _typeBox.currentIndex = 0
            _itemBox.model = courseItems
            _itemBox.currentIndex = savedCourseIndex
            console.log("savedCourseIndex",savedCourseIndex)
        }
        else if(Config.displayType === "teacher") {
            _typeBox.currentIndex = 1
            _itemBox.model = teacherItems
            console.log("savedTeacherIndex",savedTeacherIndex)
            _itemBox.currentIndex = savedTeacherIndex
        }
        else if(Config.displayType === "room") {
            _typeBox.currentIndex = 2
            _itemBox.model = roomItems
            _itemBox.currentIndex = savedRoomIndex
            console.log("savedRoomIndex",savedRoomIndex)
        }
        else {
            _itemBox.model = courseItems
            _itemBox.currentIndex = 0
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Tests the connection and saves the login data when successful
     */
    function testConnection()
    {
        // Aktuelle Einstellung an die Config, weil es der
        // Communicator braucht
        Config.setConfig(_inputUrl.text,
                         _inputUser.text,_inputPassword.text,
                         Config.displayType,Config.displayItem,
                         Config.displayId,Config.displayShortcut)
        _communicator.tryLogin(loginCallback)
    }

    /////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Callback when login test is done
     */
    function loginCallback(ok)
    {
        if(ok) {
            Config.saveConfig()
            _toast.displayMessage("Login ok")
            // und gleich die Auswahl neu laden
            d.connected = true
            querySelectionData()
        }
        else {
            d.connected = false
            _toast.displayMessage("Login fehlgeschlagen")
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Emits signal, whenever the selection by the user changes.
     */
    function emitSelectionChanged(typeIndex, itemIndex)
    {
        var t = ""
        var id = 0
        var shortcut = ""
        if(typeIndex === 0) {
            t = "course"
            id = courseIds[itemIndex]
        }
        else if(typeIndex === 1) {
            t = "teacher"
            id = teacherIds[itemIndex]
            shortcut = teacherShortcuts[itemIndex]
        }
        else if(typeIndex === 2) {
            t = "room"
            id = roomIds[itemIndex]
        }
        // Die id könnte man im Model setzen und
        // hier abfragen. Das geht, aber die ComboBox
        // spuckt dann Fehler aus.
        //console.log("ID1",model.get(index).id)


        d.type = t
        d.item = _itemBox.model.get(itemIndex).text
        d.id = id
        d.shortcut = shortcut

        console.log("d:",d.type,d.id,d.item,d.shortcut)

        Config.setConfig(_inputUrl.text,_inputUser.text,_inputPassword.text,
                         d.type,d.item,d.id,d.shortcut)

        selectionChanged(t,_itemBox.model.get(itemIndex).text,id,shortcut)
    }


    /////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Called, whenever the user clicks on a link in the text above.
     *  Now used inside a lambda because the former way was obsolete.
     */
    function linkClicked(link)
    {
        if(link === "LGPL") {
            _lgplDialog.open()
        }
        else if(link === "Apache") {
            _apacheDialog.open()
        }
        else {
            Qt.openUrlExternally(link)
        }

    }

}
