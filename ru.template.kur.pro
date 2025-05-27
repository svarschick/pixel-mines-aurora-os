TARGET = ru.template.kur

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    MinefieldCore.cpp \
    src/main.cpp \

HEADERS += \
    EMinesweeper.h \
    GameSettings.h \
    GameState.h \
    MinefieldCore.h \
    PerlinNoise.h \
    UICellModel.h

DISTFILES += \
    rpm/ru.template.kur.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.kur.ts \
    translations/ru.template.kur-ru.ts \

RESOURCES += \
    qml.qrc
