/*!
 * \file DayView.qml
 *
 *  Show the schedule for a single day
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
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

// Singleton wird in C++ registriert.
import de.edvschuleplattling.KlaTapp.Theme 1.0

// War vorher ein ScrollView. Aber der scrollte unter Android
// immer den Inhalt für einen Tag, so dass man nicht mehr zwischen
// den Tagen blättern konnte.

Flickable {

    clip: true
    contentHeight: 11 * 3 * Theme.dp(22)

    property ListModel lessonItems: ListModel {}

    Repeater {
        model: lessonItems
        delegate: Item {
            // TODO
            // Die Ausrichtung der Kästchen passt nicht exakt.
            // Eine Stunde der ganzen Klasse geht weiter rüber als die
            // der Gruppe 2
            Rectangle {
                x: (_scheduleListView.width / 5) * (column + (column === 2 ? 1 : 0))
                y: 3*Theme.dp(22)*row
                width: column === 0 ? (_scheduleListView.width - 10) / 5
                                    : ((_scheduleListView.width - 10) / 5 * 2 * columnSpan) +
                                                                      (columnSpan - 1) * 5
                height: 3*Theme.dp(22)*rowSpan - Theme.dp(3)
                color: vertretung ? Theme.colorEdvLightPurple : Theme.colorLightGrey
                // Transparent sollten nur die Vertretungsstunden
                // sein, oder nicht?
                opacity: vertretung ? 0.8 : 1.0
                Text {
                    id: t1
                    text: text1 //+ "\n" + text2
                    font.pixelSize: column === 0 ? Theme.dp(22) : Theme.dp(18)
                }
                Text {
                    id: t2
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: t1.bottom
                    text: text2 === null ? "" : text2
                    font.pixelSize: column === 0 ? Theme.dp(22) : Theme.dp(18)
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: t2.bottom
                    text: text3 === null ? "" : text3
                    font.pixelSize: column === 0 ? Theme.dp(22) : Theme.dp(18)
                }

                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: {
                        if(vertretung) parent.opacity = 0.1
                    }
                    onReleased: {
                        if(vertretung) parent.opacity = 0.8
                    }
                }
            }
        }
    }
}
