/*!
 * \file CalendarIcon.qml
 *
 *  Icon to display next to calendar entries
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

Item {
    width: 50
    height: 50

    property string month: ""
    property string day: ""

    function getGermanMonth(month) {
        switch(month) {
        case "01": return "Jan"
        case "02": return "Feb"
        case "03": return "Mrz"
        case "04": return "Apr"
        case "05": return "Mai"
        case "06": return "Jun"
        case "07": return "Jul"
        case "08": return "Aug"
        case "09": return "Sep"
        case "10": return "Okt"
        case "11": return "Nov"
        case "12": return "Dez"
        default: return ""
        }
    }

    Rectangle  {
        id: _top
        width: parent.width
        height: 30
        color: Theme.shadeColor(Theme.colorEdvPurple,70) //"black"
        Label {
            anchors.centerIn: parent
            text: getGermanMonth(month)
            font.pixelSize: 18
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Rectangle {
        anchors.top: _top.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        color: "white"
        Label {
            anchors.centerIn: parent
            text: day
            font.pixelSize: 20
            color: "black"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
