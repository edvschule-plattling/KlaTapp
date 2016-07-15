/*!
 * \file Theme.qml
 *
 *  Singleton, delivering things for look and feel
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

pragma Singleton
import QtQuick 2.5

Item {
    id: root

    property color colorEdvPurple: "#e758c8"
    property color colorEdvLightPurple: shadeColor(colorEdvPurple,80)
    property color colorEdvBackground: "#9999cc"
    property color colorEdvLightBackground: shadeColor(colorEdvBackground,50)
    property color colorLightGrey: "#f3f3f3"

    property int headerHeight: dp(50)
    property int headerPixelSize: dp(22)
    property int footerHeight: dp(30)


    property real contentScaleFactor : screenRatio // screenDpi / 160
    function dp(value) {
        return value * contentScaleFactor
    }

    // sp für font.pixelSize verwenden.
    // textScale könnte man in Abhängigkeit des System-Fonts setzen
    property real textScale: 1.0
    function sp(value) {
        return value * contentScaleFactor * textScale
    }

    function shadeColor(c, percent) {
        var color = c.toString()
        var R = parseInt(color.substring(1,3),16);
        var G = parseInt(color.substring(3,5),16);
        var B = parseInt(color.substring(5,7),16);

        R = parseInt(R * (100 + percent) / 100);
        G = parseInt(G * (100 + percent) / 100);
        B = parseInt(B * (100 + percent) / 100);

        R = (R<255)?R:255;
        G = (G<255)?G:255;
        B = (B<255)?B:255;

        var RR = ((R.toString(16).length===1)?"0"+R.toString(16):R.toString(16));
        var GG = ((G.toString(16).length===1)?"0"+G.toString(16):G.toString(16));
        var BB = ((B.toString(16).length===1)?"0"+B.toString(16):B.toString(16));

        return "#"+RR+GG+BB;
    }

}
