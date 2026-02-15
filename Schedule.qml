/*!
 * \file Schedule.qml
 *
 *  Main view for the schedule, allows navigation between days.
 *  Uses DayView for single days.
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
import QtQml.Models

// Singleton wird in C++ registriert.
import de.edvschuleplattling.KlaTapp.Theme 1.0

Rectangle {
    id: root
    color: Theme.colorEdvLightBackground //"lightgray"
    width: parent.width
    height: parent.height
    property bool printDestruction: false

    property string _desiredType: ""
    property string _desiredItem: ""
    property string _desiredId: ""
    property string _desiredShortcut: ""

    property string _currentType: ""
    property string _currentItem: ""
    property string _currentId: ""
    property string _currentShortcut: ""

    property var _readyCallback: null

    property var  _selectedDate: new Date
    property bool _firstLoad: true
    property int  _currentIndex: 0

    onVisibleChanged: console.log("SCHEDULE VISIBLE CHANGED",visible)

    Communicator {
        id: _communicator
    }

    BusyIndicator {
        id: busyIndicator
        z: 100 // on top of any other item
        anchors.centerIn: parent
        running: false
    }


    ListModel {
        id: _navigationModel
    }

    ListModel {
        id: _mondayItems
    }
    ListModel {
        id: _tuesdayItems
    }
    ListModel {
        id: _wednesdayItems
    }
    ListModel {
        id: _thursdayItems
    }
    ListModel {
        id: _fridayItems
    }

    // Model for the listview of the five days to show
    ObjectModel {
        id: _scheduleModel

        DayView {
            id: _mondayView
            width: _scheduleListView.width; height: _scheduleListView.height
        }
        DayView {
            id: _tuesdayView
            width: _scheduleListView.width; height: _scheduleListView.height
        }
        DayView {
            id: _wednesdayView
            width: _scheduleListView.width; height: _scheduleListView.height
        }
        DayView {
            id: _thursdayView
            width: _scheduleListView.width; height: _scheduleListView.height
        }
        DayView {
            id: _fridayView
            width: _scheduleListView.width; height: _scheduleListView.height
        }

    }

    Rectangle {
        id: _headLine
        width: parent.width
        height: Theme.headerHeight
        color: Theme.colorEdvPurple
        anchors {
            top: parent.top
        }
        Row {
            anchors {
                centerIn: parent
            }
            spacing: 20
            MouseArea {
                id: _buttonLeft
                height: 20
                width: 20
                Rectangle {
                    Image {
                        source: "pics/backward_white.svg"
                        anchors { fill: parent }
                        fillMode: Image.PreserveAspectFit
                    }
                    anchors { fill: parent }
                    border.color: Theme.colorEdvPurple
                    color:"transparent"
                }

                onClicked: {
                    _selectedDate.setDate(_selectedDate.getDate() - 7)
                    updateSchedule()
                }
            }
            Label {
                id: _selectedDateLabel
                color: "#ffffff"
                font.pixelSize: Theme.headerPixelSize
            }
            MouseArea {
                id: _buttonRight
                height: 20
                width: 20

                Rectangle {
                    Image {
                        source: "pics/forward_white.svg"
                        anchors { fill: parent }
                        fillMode: Image.PreserveAspectFit
                    }
                    anchors { fill: parent }
                    color:"transparent"
                }

                onClicked: {
                    _selectedDate.setDate(_selectedDate.getDate() + 7)
                    updateSchedule()
                }
            }
        }
    }


    // On top there are five dates of the current week.
    // Used to display and navigate
    Rectangle {
        id: _navigationBar

        anchors {
            top: _headLine.bottom
        }

        height: Theme.headerHeight
        color: Theme.colorEdvPurple

        width: root.width;

        ListView {
            id: _dateListView
            property int delegateWidth: width / 1.5

            anchors.fill: parent
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: ((width - delegateWidth) / 2)
            preferredHighlightEnd: preferredHighlightBegin + delegateWidth
            highlightMoveDuration: Theme.dp(400)

            onCurrentIndexChanged: _scheduleListView.currentIndex = currentIndex

            model: _navigationModel

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
                        // warum ist da unter Windows ein Unterschied? (dp(34) und das Property)
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

    // this listview displays all the lessons
    ListView {
        id: _scheduleListView
        anchors {
            fill: parent
            topMargin: _headLine.height + _navigationBar.height
        }
        model: _scheduleModel
        preferredHighlightBegin: 0;
        preferredHighlightEnd: 0
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem; flickDeceleration: 2000
        highlightMoveDuration: Theme.dp(600)
        cacheBuffer: 200
        onCurrentIndexChanged: _dateListView.currentIndex = currentIndex
    }

    // five bullets at the bottom to show one of the five day a week
    Rectangle {
        id: _bottom
        width: root.width; height: Theme.footerHeight
        anchors { bottom: parent.bottom }
        color: Theme.colorEdvBackground

        Row {
            anchors.centerIn: parent
            height: parent.height
            spacing: Theme.dp(20)

            Repeater {
                model: _scheduleModel.count
                height: parent.height
                anchors.centerIn: parent

                Rectangle {
                    width: 5;
                    height: 5;
                    // TODO hier kommt eine Warning wegen Ankerzeile, aber es geht...
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 3
                    color: _scheduleListView.currentIndex == index ? "blue" : "white"

                    MouseArea {
                        width: 20; height: 20
                        anchors.centerIn: parent
                        onClicked: _scheduleListView.currentIndex = index
                    }
                }
            }
        }
    }


    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Starts loading the schedule
     */
    function loadSchedule(type, item, id, shortcut, callback)
    {
        // always load data even if selection did not change
        // if(type === _currentType && id === _currentId &&
        //         item === _currentItem && shortcut === _currentShortcut) {
        //     return
        // }

        _desiredType = type
        _desiredItem = item
        _desiredId = id
        _desiredShortcut = shortcut
        _readyCallback = callback

        updateSchedule(callback)
    }


    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Loads schedule for the right date.
     *  Especially called, when date selection changes.
     */
    function updateSchedule() {
        busyIndicator.running = true;

        _currentIndex = _dateListView.currentIndex
        _mondayItems.clear()
        _tuesdayItems.clear()
        _wednesdayItems.clear()
        _thursdayItems.clear()
        _fridayItems.clear()

        var url = "/?Request=Timetable&Variant="
        switch(_desiredType)
        {
        case "course": url += "c&Key=" + _desiredId;
            break;
        case "teacher": url += "t&Key=" + _desiredId;
            break;
        case "room": url += "r&Key=" + _desiredId;
            break;
        default:
            busyIndicator.running = false
            return;
        }
        url += "&Date="+_selectedDate.toISOString().split('T')[0]

        _communicator.httpRequest(url,scheduleCallback)
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Called from Communicator after finishing a request.
     */
    function scheduleCallback(json,ok)
    {
        // Das Array enthält der Reihe nach
        // Stundenplansätze

        if(ok !== true) {
            busyIndicator.running = false
            return false
        }

        var lessons = json

        if(lessons.errors !== undefined)  {
            console.log("ERROR IM JSON",lessons.erros)
            busyIndicator.running = false
            return false
        }
        if(typeof(lessons) != 'object') {
            // da ist was faul
            // TODO Fehlermeldung als Toast?
            // fürchte, da kommt man nicht her
            // wenn das Netz spinnt
            console.log("AM JSON IST WAS FAUL")
            busyIndicator.running = false
            return false
        }

        var lm;
        for(var i = 0; i < lessons.length; i++) {
            switch(lessons[i]["dayNo"]) {
            case 0: lm = _mondayItems; break;
            case 1: lm = _tuesdayItems; break;
            case 2: lm = _wednesdayItems; break;
            case 3: lm = _thursdayItems; break;
            case 4: lm = _fridayItems; break;
            }

            var row = lessons[i]["hourFrom"]
            var rowspan = lessons[i]["hourTo"] - lessons[i]["hourFrom"] + 1
            var column = lessons[i]["groupNo"] === 2 ? 2 : 1
            var columnspan = lessons[i]["groupNo"] === 0 ? 2 : 1
            var raum = lessons[i]["roomNo"];
            var lehrer = lessons[i]["teacherShort"]
            var fach = lessons[i]["subjectName"]
            var klasse = lessons[i]["className"]
            var al = lessons[i]["classAlias"]
            var vertretung = lessons[i]["standIn"]
            var notiz = lessons[i]["extraNote"]

            var text1 = lehrer + "  " + raum + "  " + al
            var text2 = fach //klasse
            var text3 = notiz //fach

            lm.append( {  "row" : row ,
                          "column" : column,
                          "rowSpan" : rowspan,
                          "columnSpan" : columnspan,
                          "text1" : text1,
                          "text2" : text2,
                          "text3" : text3,
                          "vertretung" : vertretung })
        }
        // noch die Zeiten in die erste Spalte
        addTimeEntries(_mondayItems)
        addTimeEntries(_tuesdayItems)
        addTimeEntries(_wednesdayItems)
        addTimeEntries(_thursdayItems)
        addTimeEntries(_fridayItems)
        // und die Models für die Tage setzen
        _mondayView.lessonItems  = _mondayItems
        _tuesdayView.lessonItems = _tuesdayItems
        _wednesdayView.lessonItems = _wednesdayItems
        _thursdayView.lessonItems = _thursdayItems
        _fridayView.lessonItems = _fridayItems

        _navigationModel.clear()

        var today = _selectedDate
        var locale = Qt.locale()
        if(locale.firstDayOfWeek === Locale.Sunday) {
            // TODO
            console.log("FIRST DAY OF WEEK IST SUNDAY")
        }

        console.log("DAYOFWEEK",today.getDay(),"  today",today)

        // on saturday or sunday, switch to the next week
        if(today.getDay() === 6) {
            today.setDate(today.getDate() + 2)
        }
        else if(today.getDay() === 0) {
            today.setDate(today.getDate() + 1)
        }

        var dow = _selectedDate.getDay()
        var monday = new Date(today.getTime()); monday.setDate(monday.getDate() - (dow-1))
        var tuesday = new Date(monday.getTime()); tuesday.setDate(monday.getDate() + 1)
        var wednesday = new Date(monday.getTime()); wednesday.setDate(monday.getDate() + 2)
        var thursday = new Date(monday.getTime()); thursday.setDate(monday.getDate() + 3)
        var friday = new Date(monday.getTime()); friday.setDate(monday.getDate() + 4)

        _navigationModel.append( { "day" : "<b>Montag</b>", "date" : monday } )
        _navigationModel.append( { "day" : "<b>Dienstag</b>", "date" : tuesday } )
        _navigationModel.append( { "day" : "<b>Mittwoch</b>", "date" : wednesday } )
        _navigationModel.append( { "day" : "<b>Donnerstag</b>", "date" : thursday } )
        _navigationModel.append( { "day" : "<b>Freitag</b>", "date" : friday } )

        _selectedDateLabel.text = monday.toLocaleString(Qt.locale(),"dd.M.yyyy") + " - " + friday.toLocaleString(Qt.locale(),"dd.M.yyyy")

        // show the right page for the day

        // BUG: Wenn man am Montag bei einer Klasse
        // auf Freitag blättert und dann einen andere
        // Klasse wählt, bleibt die Datumsanzeige stehen.
        // Intern ist sie scheinbar auf Montag, aber nicht
        // optisch...
        // Frage: Soll der aktuelle Wochentag nicht einfach
        // stehenbleiben??? - Ja soll er.

        // Hack: zweimal schalten, dann schnallt er es vielleicht?
        //_dateListView.currentIndex = dow
        if (_firstLoad){
            _dateListView.currentIndex = dow - 1
            _firstLoad = false
        }else {
            _dateListView.currentIndex = _currentIndex
        }

        console.log("SHOW CURRENT DAY",dow -1 )

        busyIndicator.running = false

        _currentType = _desiredType
        _currentItem = _desiredItem
        _currentId = _desiredId
        _currentShortcut = _desiredShortcut

        _readyCallback(ok,_currentItem)

        return true
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  The first column for each day shows the times. Those are inserted into the model.
     */
    function addTimeEntries(lm)
    {
        lm.append( {  "row" : 0 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "08:00" /*-\n08:45"*/, "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 1 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "08:45", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 2 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "09:45", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 3 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "10:30", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 4 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "11:30", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 5 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "12:15", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 6 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "13:00", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 7 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "13:45", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 8 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "14:45", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 9 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "15:30", "text2" : "", "text3" : "" , "vertretung" : false})
        lm.append( {  "row" : 10 , "column" : 0, "rowSpan" : 1, "columnSpan" : 1, "text1" : "16:15", "text2" : "", "text3" : "" , "vertretung" : false})
    }
}
