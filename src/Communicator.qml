/*!
 * \file Communicator.qml
 *
 *  Component for doing the networking stuff
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

import QtQuick 2.5
import QtQuick.Controls 1.4

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


    ////////////////////////////////////////////////////////////////////////////////////
    /*!
     *  Try to login to the server.
     */
    function tryLogin(callback)
    {
        console.log("TRY LOGIN")

        var url = "https://"
                  + Config.serviceBaseUrl
                  + "/KlaTabService.php?SearchNach=Login"
        var res
        var doc = new XMLHttpRequest()

        doc.onreadystatechange = function()
        {
            console.log("onreadystatechange", doc.readyState, XMLHttpRequest.DONE)

            if(doc.readyState === XMLHttpRequest.DONE) {
                res = doc.responseText
                // TODO erkennen, wenn es nicht klappt
                // z.B. wenn unter Windows ssl nicht geht.
                console.log("LOGIN DONE")
                //console.log(res)
                var json
                try {
                  json = JSON.parse(res)
                }
                catch(e) {
                    callback(false)
                    return;
                }

                // TODO bug im Service
                if(json["sucess"] === 1) {
                    console.log("ok")
                    callback(true)
                }
                else {
                    console.log("fail")
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

        url = "https://" + Config.serviceBaseUrl + url

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
