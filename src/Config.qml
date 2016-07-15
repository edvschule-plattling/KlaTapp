/*!
 * \file Config.qml
 *
 *  Saving users settings
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

import Qt.labs.settings 1.0

Item {

    property string serviceBaseUrl: _qsettings.serviceBaseUrl
    property string serviceUser: _qsettings.serviceUser
    property string servicePassword: _qsettings.servicePassword
    property string displayType: _qsettings.displayType
    property string displayItem: _qsettings.displayItem
    property string displayId: _qsettings.displayId
    property string displayShortcut: _qsettings.displayShortcut

    Settings {
        id: _qsettings
        property string serviceBaseUrl: ""
        property string serviceUser: ""
        property string servicePassword: ""
        property string displayType : ""
        property string displayItem : ""
        property string displayId : ""
        property string displayShortcut : ""
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Set configuration values for runtime, when the user changes them.
     */
    function setConfig(baseurl, user, password, type, item, id, shortcut) {
        console.log("Config.setConfig:",baseurl,user,password)
        console.log("  type",type)
        console.log("  item",item)
        console.log("  id",id)
        console.log("  shortcut",shortcut)
        serviceBaseUrl = baseurl
        serviceUser = user
        servicePassword = password
        displayType = type          // e.g. teacher    room   course
        displayItem = item          // e.g. Meier      206    12a
        displayId = id              // e.g. 12         206    bfs2013ik
        displayShortcut = shortcut  // e.g. Me
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Saved current settings.
     */
    function saveConfig() {
        _qsettings.serviceBaseUrl = serviceBaseUrl
        _qsettings.serviceUser = serviceUser
        _qsettings.servicePassword = servicePassword
        _qsettings.displayType = displayType
        _qsettings.displayItem = displayItem
        _qsettings.displayId = displayId
        _qsettings.displayShortcut = displayShortcut
    }

}
