
QT += qml quick
android {
QT +=androidextras
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

SOURCES += \
    main.cpp \
    filereader.cpp

OTHER_FILES += \
    qml/main.qml \
    android-sources/src/org/qtproject/example/testapi/NotificationClient.java \
    android-sources/AndroidManifest.xml

RESOURCES += \
    main.qrc
    
QML_IMPORT_PATH += /usr/share/qml/
QML2_IMPORT_PATH += /usr/share/qml/

HEADERS += \
    filereader.h
android {
SOURCES += \
    notificationclient.cpp
HEADERS += \
    notificationclient.h
}


