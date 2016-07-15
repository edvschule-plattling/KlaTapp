/*!
 * \file RoomSearch.qml
 *
 *  Allows to search for a free room at a certain time.
 *  tbd.
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

// nur wegen SliderStyle
import QtQuick.Controls.Styles 1.4

import QtQuick.Layouts 1.1

// Singleton wird in C++ registriert.
import de.edvschuleplattling.KlaTapp.Theme 1.0

Rectangle {
    id: _root
    color: Theme.colorEdvLightBackground

    ListModel {
        id: _dateModel
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

        Slider {
            id: _from
            minimumValue: 0
            maximumValue: 35
            stepSize: 1
            Layout.column: 0
            Layout.columnSpan: 4
            Layout.row: 1
            Layout.leftMargin: Theme.dp(10)
            Layout.minimumWidth: 3 * _root.width / 4
            Layout.minimumHeight: Theme.dp(50)

            style: SliderStyle {
                groove: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 8
                    color: "gray"
                    radius: 8
                }
                handle: Rectangle {
                    anchors.centerIn: parent
                    color: control.pressed ? Theme.colorEdvPurple
                                           : Theme.colorEdvBackground
                    border.color: "gray"
                    border.width: Theme.dp(2)
                    implicitWidth: Theme.dp(34)
                    implicitHeight: Theme.dp(34)
                    radius: Theme.dp(12)
                }
             }
            onValueChanged: {
                _to.value = Math.max(_to.value, value + 1)
                _fromLabel.text = makeTimeFromValue(15*value)
            }


        }

        Label {
            id: _fromLabel
            text: "08:00"
            font.pixelSize: Theme.headerPixelSize
            Layout.column: 4
            Layout.row: 1
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Theme.dp(10)
        }

        Slider {
            id: _to
            minimumValue: 1
            maximumValue: 36
            Layout.column: 0
            Layout.columnSpan: 4
            Layout.row: 2
            Layout.leftMargin: Theme.dp(10)
            Layout.minimumWidth: 3 * _root.width / 4
            Layout.minimumHeight: Theme.dp(50)


            stepSize: 1
            style: SliderStyle {
                groove: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 8
                    color: "gray"
                    radius: 8
                }
                handle: Rectangle {
                    anchors.centerIn: parent
                    color: control.pressed ? Theme.colorEdvPurple
                                           : Theme.colorEdvBackground
                    border.color: "gray"
                    border.width: Theme.dp(2)
                    implicitWidth: Theme.dp(34)
                    implicitHeight: Theme.dp(34)
                    radius: Theme.dp(12)
                }
            }
            onValueChanged: {
                _from.value = Math.min(_from.value, value - 1)
                if(_toLabel) {
                    // wird wohl schon ausgelöst, wenn es _toLabel noch nicht gibt
                    _toLabel.text = makeTimeFromValue(15*value)
                }
            }
        }
        Label {
            id: _toLabel
            text: "08:15"
            font.pixelSize: Theme.headerPixelSize
            Layout.column: 4
            Layout.row: 2
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Theme.dp(10)
        }
    }  // Ende Layout

    Button {
        id: _searchButton
        height: Theme.dp(50)
        width: Theme.dp(50)
        anchors { top: _grid.bottom; horizontalCenter:  _grid.horizontalCenter;
                  topMargin: Theme.dp(10) }
        style: ButtonStyle {
            background:
                Rectangle {
                    Image {
                        source: "pics/ic_zoom_in_black_24dp.png"
                        anchors { fill: parent }
                        height: Theme.dp(30)
                        fillMode: Image.PreserveAspectFit
                    }
                    anchors { fill: parent }
                    height: Theme.dp(30)
                    border.color: Theme.colorEdvPurple
                    color:  control.pressed ? Theme.colorEdvPurple
                                            :  Theme.colorEdvLightBackground
                }
        }

        onClicked: {
            //
        }
    }

    Label {
        text: "Coming soon..."
        anchors { top: _searchButton.bottom; topMargin: Theme.dp(20);
                  horizontalCenter:  _grid.horizontalCenter }
    }


    Rectangle {
        id: _footer
        width: parent.width;
        height: Theme.footerHeight
        anchors {  bottom: parent.bottom }
        color: Theme.colorEdvBackground
    }

    Component.onCompleted: {

        // Raumsuche ab heute für 14 Tage
        // TODO: Wenn sich das Datum ändert während die App noch läuft,
        //       dann sollte man aktualsieren
        var today = new Date()

        var daynames = [ "Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag",
                         "Freitag", "Samstag" ]

        // In JavaScript liefert getDay die Nummern immer passend zu obigem Array

        for(var i = 0; i < 14; i++) {
            _dateModel.append( { "day" : "<b>" + daynames[today.getDay()] +
                                  "</b>", "date" : today } )
            today.setDate(today.getDate() + 1)
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Converts the slider value to a time.
     */
    function makeTimeFromValue(value)
    {
        var d = new Date(2015, 12, 18, 8, 0, 0, 0);
        d = new Date(d.getTime() + value*60000)
        //return d.toTimeString()
        return ("0" + d.getHours()).slice(-2)   + ":" +
               ("0" + d.getMinutes()).slice(-2);
    }

}



