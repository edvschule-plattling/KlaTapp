/*!
 * \file networkaccessmanager.cpp
 *
 *  Used for suppressing ssl-based errors
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

#include "networkaccessmanager.h"
#include <QNetworkReply>

NetworkAccessManager::NetworkAccessManager(QObject *parent)
                     :QNetworkAccessManager(parent)
{
    qDebug() << "NetworkAccessManager";
    //  connect(this, SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)),
    //          this, SLOT(onSSLErrors(QNetworkReply*,QList<QSslError>)));
    connect(this,SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)),
            this,SLOT(onSSLErrors(QNetworkReply*,QList<QSslError>)));
}

void NetworkAccessManager::onSSLErrors(QNetworkReply *reply, QList<QSslError> errors)
{
    // Die kommt gar nicht
    qDebug() << "onSSLError";
    reply->ignoreSslErrors(errors);
}

