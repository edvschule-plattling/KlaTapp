/*!
 *  \file main.cpp
 *
 *  Startup-File for KlaTapp
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

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QScreen>
#include <QFile>
#include <QTextStream>

#ifdef Q_OS_ANDROID
# include <QAndroidJniEnvironment>
# include <QAndroidJniObject>
#endif

#include "networkaccessmanagerfactory.h"

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
    QGuiApplication a(argc, argv);
    a.setOrganizationName("EDV-Schule Plattling");
    a.setOrganizationDomain("edvschule-plattling.de");
    a.setApplicationName("KlaTapp");

    qreal dpi;
#if defined(Q_OS_WIN)
    QScreen *screen = QGuiApplication::primaryScreen();
    dpi = screen->logicalDotsPerInch() * a.devicePixelRatio();
#elif defined(Q_OS_ANDROID)
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");

    QAndroidJniObject resources = activity.callObjectMethod("getResources",
                                                            "()Landroid/content/res/Resources;");

    QAndroidJniObject displayMetrics = resources.callObjectMethod("getDisplayMetrics",
                                                                  "()Landroid/util/DisplayMetrics;");

    jint densityDpi = displayMetrics.getField<jint>("densityDpi");

    dpi = densityDpi;
#else
    QScreen *screen = QGuiApplication::primaryScreen();
    qDebug() << "Physical:" << screen->physicalDotsPerInch()
             << " Logical:" << screen->logicalDotsPerInch()
             << " Ratio  :" << a.devicePixelRatio();
    dpi = screen->logicalDotsPerInch() * a.devicePixelRatio();
#endif

    // Default sind die Desktop-Größen
    qreal width = 320;
    //qreal height = 544;
#if defined(Q_OS_ANDROID)
    QRect rect = qApp->primaryScreen()->geometry();
    //height = qMax(rect.width(), rect.height());
    width = qMin(rect.width(), rect.height());
#endif

    // Beim p8 lite kam ich nach der dpi gerechnet auf einen Faktor
    // von 1.8375, da hatte es gut ausgesehen.
    // 1.7 macht einen guten Eindruck
    qreal screenRatio = width * 1.7 / 720;


    QQmlApplicationEngine engine;

    // War mal als Workaround wegen Zertifikatsproblemen notwendig.
    // Dürfte nun auch ohne funktionieren.
    NetworkAccessManagerFactory factory;
    engine.setNetworkAccessManagerFactory(&factory);

    qmlRegisterSingletonType( QUrl("qrc:/Theme.qml"),
                              "de.edvschuleplattling.KlaTapp.Theme",
                              1, 0, "Theme" );
    qmlRegisterSingletonType( QUrl("qrc:/Config.qml"),
                              "de.edvschuleplattling.KlaTapp.Config",
                              1, 0, "Config" );

    QFile f(":lgpl.txt");
    f.open(QFile::ReadOnly | QFile::Text);
    QString lgpl = QTextStream(&f).readAll();

    QQmlContext *context = engine.rootContext();
    context->setContextProperty("screenDpi",dpi);
    context->setContextProperty("screenRatio",screenRatio);
    context->setContextProperty("lgpltext",lgpl);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return a.exec();
}
