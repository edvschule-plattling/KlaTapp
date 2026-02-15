/*!
 * \file Communicator.qml
 *
 *  Component for doing the networking stuff
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
// Singleton wird in C++ registriert.
import de.edvschuleplattling.KlaTapp.Config 1.0

Item {

// Der würde schon funktionieren, nur die Position ist links oben
// statt im Zentrum
//    BusyIndicator {
//        id: _busyIndicator
//        anchors.centerIn: parent.Center
//        running: false
//    }

    readonly property string _serviceBaseUrl : "<enter service url here>"

    ////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Try to login to the server.
     */
    function tryLogin(callback)
    {
        console.error("TRY LOGIN")

        var url = "https://"
                  //+ Config.serviceBaseUrl
                  + _serviceBaseUrl
                  + "?Request=Login"
        var res
        var doc = new XMLHttpRequest()

        doc.onreadystatechange = function()
        {
            console.error("onreadystatechange", doc.readyState, XMLHttpRequest.DONE)

            if(doc.readyState === XMLHttpRequest.DONE) {
                res = doc.responseText
                // TODO erkennen, wenn es nicht klappt
                // z.B. wenn unter Windows ssl nicht geht.
                console.error("LOGIN DONE")
                console.error("res=",res)
                var json
                try {
                  json = JSON.parse(res)
                }
                catch(e) {
                    console.error("login exception",e)
                    callback(false)
                    return;
                }

                // TODO bug im Service
                if(json["success"] === true) {
                    console.error("ok")
                    callback(true)
                }
                else {
                    console.error("fail")
                    callback(false)
                }
            }
        }
        doc.open("GET",url);
        doc.setRequestHeader("Authorization","Basic "
                            + Qt.btoa(Config.serviceUser
                             + ":" + Config.servicePassword))
        doc.send()
    }

    /////////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Start a request to the webservice.
     */
    function httpRequest(url,callback)
    {
        var res
        var doc = new XMLHttpRequest()

        url = "https://"
                //+ Config.serviceBaseUrl
                + _serviceBaseUrl
                + url

        doc.onreadystatechange = function()
        {
            console.log("onreadystatechange", doc.readyState, XMLHttpRequest.DONE)

            if(doc.readyState === XMLHttpRequest.DONE) {
                //_busyIndicator.running = false
                res = doc.responseText
                var json
                try {
                  json = JSON.parse(res)
                }
                catch(e) {
                    callback(null,false)
                    return;
                }
                callback(json,true)
            }
        }
        doc.open("GET",url);
        doc.setRequestHeader("Authorization","Basic " +
                             Qt.btoa(Config.serviceUser + ":" + Config.servicePassword))
        //_busyIndicator.running = true
        doc.send()
    }

}
