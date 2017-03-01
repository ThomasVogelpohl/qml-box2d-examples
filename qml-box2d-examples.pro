    TEMPLATE = app

QT += qml quick
CONFIG += c++11
CONFIG += qtquickcompiler

SOURCES += main.cpp

# RESOURCES += qml.qrc
RESOURCES += ./qml-box2d/examples/example.qrc

ios {
    message(Platform: ios)
    #DEFINES += B2_USE_16_BIT_PARTICLE_INDICES
    #DEFINES += LIQUIDFUN_SIMD_NEON

    #QMAKE_CFLAGS_RELEASE = -O3 -march=armv7-a -mfpu=neon -mfloat-abi=softfp
    #QMAKE_CXXFLAGS_RELEASE = -O3 -march=armv7-a -mfpu=neon -mfloat-abi=softfp


} android {
    message(Platform: android)
    DEFINES += B2_USE_16_BIT_PARTICLE_INDICES
    DEFINES += LIQUIDFUN_SIMD_NEON

    QMAKE_CFLAGS_RELEASE = -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
    QMAKE_CXXFLAGS_RELEASE = -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
    QMAKE_CFLAGS_DEBUG = -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
    QMAKE_CXXFLAGS_DEBUG = -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
} macx:!linux {
    message(Platform: macx)

} linux:!android {
    message(Platform: unix)
}    


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =
INCLUDEPATH += ./qml-box2d/Box2D

# Rules for static QML-Box2D
include(qml-box2d/box2d-static.pri)

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
