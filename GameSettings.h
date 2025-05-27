#ifndef GAMESETTINGS_H
#define GAMESETTINGS_H

#include <QSharedPointer>
#include <QWeakPointer>
#include <QObject>
#include <QDebug>

#include "MinefieldCore.h"
#include "EMinesweeper.h"

namespace minesweeper {

class GameSettings : public QObject {

    Q_OBJECT

    Q_PROPERTY ( quint16 heightMinefield READ getHeightMinefield NOTIFY heightMinefieldChanged )
    Q_PROPERTY ( quint16 widthMinefield  READ getWidthMinefield  NOTIFY widthMinefieldChanged  )
    Q_PROPERTY ( quint32 minesMinefield  READ getMinesMinefield  NOTIFY minesMinefieldChanged  )

private:
    constexpr static const quint16 _MAX_HEIGHT = 2000;
    constexpr static const quint16 _MAX_WIDTH  = 2000;
    constexpr static const quint32 _MAX_MINES  = 20000;

public:
    GameSettings(QObject* qobj_p = nullptr) : QObject(qobj_p), _height(0), _width(0), _mines(0) {}
    GameSettings(quint16 height, quint16 width, quint32 mines, QObject* qobj_p = nullptr) : QObject(qobj_p) {
        setHeightMinefield(height);
        setWidthMinefield(width);
        setMinesMinefield(mines);
    }

    quint16 getHeightMinefield () const { return _height; }
    quint16 getWidthMinefield  () const { return _width; }
    quint32 getMinesMinefield  () const { return _mines; }

    void setHeightMinefield (quint16 value) {
        if (_MAX_HEIGHT < value)
            throw EInvalidUIInitialization("height: " + QString::number(value) + " more than max: " + QString::number(_MAX_HEIGHT));
        else _height = value;
    }
    void setWidthMinefield (quint16 value) {
        if (_MAX_WIDTH < value)
            throw EInvalidUIInitialization("width: " + QString::number(value) + " more than max: " + QString::number(_MAX_WIDTH));
        else _width = value;
    }
    void setMinesMinefield (quint32 value) {
        if (_MAX_MINES < value)
            throw EInvalidUIInitialization("mines: " + QString::number(value) + " more than max: " + QString::number(_MAX_MINES));
        else _mines = value;
    }
    Q_INVOKABLE void setProperties(quint16 height, quint16 width, quint32 mines) {
        qDebug() << "input settings: height:" << height << "; width:" << width << "; mines: " << mines;
        _height = height;
        _width = width;
        _mines = mines;
        emit readyProperties();
    }

signals:
    void heightMinefieldChanged(quint16);
    void widthMinefieldChanged (quint16);
    void minesMinefieldChanged (quint32);
    void readyProperties();

private:
    quint16 _height;
    quint16 _width;
    quint32 _mines;
};

}

#endif // GAMESETTINGS_H
