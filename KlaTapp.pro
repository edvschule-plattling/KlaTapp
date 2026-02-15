# KlaTapp.pro
# Qt project file for qmake
#
#  This file is part of KlaTapp.
#  Copyright 2015-2026 EDV-Schule Plattling <www.edvschule-plattling.de>.
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

QT += quick

SOURCES += \
        main.cpp

RESOURCES += \
        qml.qrc

# you need to add AndroidManifest here, otherwise you can not edit it with qtcreator...
DISTFILES += \
        android/AndroidManifest.xml


# Android requires pagesize of 16 KB
android {
    QMAKE_LFLAGS += -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384
}

# setting variables that are replaced automatically in AndroidManifest.xml
ANDROID_VERSION_CODE = 13
ANDROID_VERSION_NAME = 1.3.0

# the ssl libs are needed for the different android bundles
# they are installed by the assistant in qtcreator
ANDROID_EXTRA_LIBS += \

# the next is needed so that AndroidManifest and the like are bundled
ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
