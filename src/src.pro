#-------------------------------------------------
#
# src.pro
#
# Project-file for QtCreator / qmake
#
#-------------------------------------------------
#
#  This file is part of KlaTapp.
#  Copyright 2015-2016 EDV-Schule Plattling <www.edvschule-plattling.de>.
#
#  KlaTapp is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  KlaTapp is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with KlaTapp.  If not, see <http://www.gnu.org/licenses/>.
#


QT       += qml quick core network #svg
# svg ist nur wegen Android notwendig, weil sonst die
# svg-Icons nicht angezeigt werden.
# Aber das apk wird dann 2MB größer => lieber png

android {
    QT += androidextras
}

#greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = KlaTabQt
TEMPLATE = app

SOURCES += main.cpp \
           networkaccessmanagerfactory.cpp \
           networkaccessmanager.cpp

HEADERS  += networkaccessmanagerfactory.h \
            networkaccessmanager.h

FORMS    +=

CONFIG += mobility
CONFIG += c++11
MOBILITY = 

RESOURCES += \
    gui.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
