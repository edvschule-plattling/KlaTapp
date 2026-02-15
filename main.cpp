/*!
 *  \file main.cpp
 *
 *  Startup-File for KlaTapp
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

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QScreen>
#include <QFile>
#include <QTextStream>
#include <QFont>
#include <QIcon>

// ACHTUNG ACHTUNG
//
// Wenn man für Android die Standard-Qt-Features und Permissions nicht
// haben möchte, dann muss man unter Projekte/Erstellung für Android
// den Keystore usw. auswählen und das Paket signieren, sonst stürzt das
// Programm dann immer ab.
//
// ACHTUNG ACHTUNG


int main(int argc, char *argv[])
{
    //QFont font("Montserrat");
    //QGuiApplication::setFont(font);

    QGuiApplication a(argc, argv);
    a.setOrganizationName("EDV-Schule Plattling");
    a.setOrganizationDomain("edvschule-plattling.de");
    a.setApplicationName("KlaTapp");
    a.setWindowIcon(QIcon(":pics/KlaTapp100.png"));

    // Ausgeben der SSL-Version, weil es ab Android 7 nicht
    // mehr funktionierte.
    qDebug() << "SSL-Version: " << QSslSocket::sslLibraryVersionString();

    // Default sind die Desktop-Größen
    qreal width = 320;
#if defined(Q_OS_ANDROID)
    QRect rect = qApp->primaryScreen()->geometry();
    width = qMin(rect.width(), rect.height());
#endif

    // Beim p8 lite kam ich nach der dpi gerechnet auf einen Faktor
    // von 1.8375, da hatte es gut ausgesehen.
    // 1.7 macht einen guten Eindruck
    qreal screenRatio = width * 1.7 / 720;

    QQmlApplicationEngine engine;

    qmlRegisterSingletonType( QUrl("qrc:/Theme.qml"),
                              "de.edvschuleplattling.KlaTapp.Theme",
                              1, 0, "Theme" );
    qmlRegisterSingletonType( QUrl("qrc:/Config.qml"),
                              "de.edvschuleplattling.KlaTapp.Config",
                              1, 0, "Config" );

    // Import license texts on startup
    QString lgpl = "LGPL not available.";
    QFile fl(":lgpl.txt");
    if(fl.open(QFile::ReadOnly | QFile::Text)) {
        lgpl = QTextStream(&fl).readAll();
    }
    QString apache = "Apache license not available.";
    QFile fa(":apache.txt");
    if(fa.open(QFile::ReadOnly | QFile::Text)) {
        apache = QTextStream(&fa).readAll();
    }

    QQmlContext *context = engine.rootContext();
    context->setContextProperty("screenRatio",screenRatio);
    context->setContextProperty("lgpltext",lgpl);
    context->setContextProperty("apachetext",apache);

    // SSL-Version wird bei den Settings angezeigt.
    context->setContextProperty("sslVersion",QSslSocket::sslLibraryVersionString());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return a.exec();
}
