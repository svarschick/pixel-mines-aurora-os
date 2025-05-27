#ifndef GAMESTATE_H
#define GAMESTATE_H

#include <QObject>
#include <QDebug>
#include <QSharedPointer>
#include <QtGlobal>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <unordered_set>
#include <chrono>
#include <string>
#include <vector>

#include "MinefieldCore.h"
#include "UICellModel.h"
#include "GameSettings.h"

namespace minesweeper {

class UIButtonHandler : public QObject {

    Q_OBJECT

public:
    UIButtonHandler(QObject* qobj_p = nullptr) : QObject(qobj_p) {}

public slots:
    void setFlagSlot(bool enableFlag) {
        _flag = enableFlag;
        emit flagStateSignal(_flag);
    }
signals:
    void flagStateSignal(bool);

private:
    bool _flag;

};

class GameState : public QObject {

    Q_OBJECT

    Q_PROPERTY ( qint32 flagSetted READ getFlagSetted NOTIFY flagSettedChanged )
    Q_PROPERTY ( qint32 score READ getScore NOTIFY scoreChanged )
    Q_PROPERTY ( qint32 totalMines READ getTotalMines NOTIFY totalMinesChanged )

public:
    GameState(QObject* qobj_p = nullptr) : QObject(qobj_p) {}

    void initial(QSharedPointer<GameSettings> gameSettings_p, QQuickView* engine) {
        // initial game settings
        _gameSettings_p = gameSettings_p;
        _engine = engine;
        bool connected = QObject::connect( &(*_gameSettings_p), SIGNAL(readyProperties()), &(*this), SLOT(start()) );
        if (connected) {
            qDebug() << "readyProperties->start connected!";
        }
        qDebug() << ">> game initial";
        _gameSettings_p->setProperties(20, 20, 40);
    }

    QSharedPointer<UICellModel> getUICellModel() { return _uiCells_p; }

    qint32 getFlagSetted() { return _flagSetted; }
    qint32 getScore() { return _score; }
    qint32 getTotalMines() { return _gameSettings_p->getMinesMinefield(); }

public slots:
    void cellClickedSlot(quint32 index) {
        qDebug() << "cellClickedSlot got signal!!!!";
        RevealResult rr;

        if (_firstClick) {
            _mcore_p->pureStart(index);
            _mcore_p->assignMineHints();
            _firstClick = false;
        }
        rr = _baseClick(index);

    }
    void cellSetFlagSlot(quint32 index) {
        qDebug() << "\nset flag\n";
        _mcore_p->changeFlag(index);
        updateUserStatus();
        _uiCells_p->updateData(_mcore_p);
    }
    void shuffleSlot() {
        qDebug() << "from suffle slot";

        auto start_time = std::chrono::steady_clock::now();
        _mcore_p->shuffleMines();
        _mcore_p->assignMineHints();
        auto end_time = std::chrono::steady_clock::now();
        qDebug() << "--] TIME [-- shuffleSlot :" << std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count() << "ms";
        _uiCells_p->updateData(_mcore_p);
    }
    void updateUserStatus() {
        auto set = _mcore_p->getChangedIndex();
        auto cells = _mcore_p->getCells();
        for (auto i_cell : set) {
            Cell cell = cells[i_cell];
            if (cell.isRevealed) {
                if (!_vboolOpenedField[i_cell]) {
                    _cellOpened += 1;
                    _score += cell.value;
                }
                _vboolOpenedField[i_cell] = true;
            }
            if (_vboolFlagField[i_cell] != cell.hasFlag) {
                if (cell.hasFlag) {
                    _flagSetted += 1;
                    _bombFinded += cell.value == 9 ? 1 : 0;
                } else {
                    _flagSetted -= 1;
                    _bombFinded += cell.value == 9 ? -1 : 0;
                }
                _vboolFlagField[i_cell] = cell.hasFlag;
            }
        }
        qDebug() << "_cellOpened: " << _cellOpened << "; _mcore_p->getCells().size(): " << _mcore_p->getCells().size()
               << " ; _gameSettings_p->getMinesMinefield(): " << _gameSettings_p->getMinesMinefield();
        if (_gameSettings_p->getMinesMinefield() == _bombFinded && _bombFinded == _flagSetted
            && _cellOpened == _mcore_p->getCells().size() - _gameSettings_p->getMinesMinefield()) {
            _isWin = true;
            qDebug() << "you win!";
            emit youWin();
        }

        emit flagSettedChanged();
        emit scoreChanged();
    }
    void start() {
        _flagSetted = 0;
        _bombFinded = 0;
        _cellOpened = 0;
        _score      = 0;
        _firstClick = true;

        qDebug() << ">> game start";
        // create game core
        _mcore_p = QSharedPointer<MinefieldCore>(
            new MinefieldCore(_gameSettings_p->getHeightMinefield(),
                              _gameSettings_p->getWidthMinefield(),
                              _gameSettings_p->getMinesMinefield()));
        _mcore_p->shuffleMines();

        // create UI cells. manual addition to the context is required!
        _uiCells_p = QSharedPointer<UICellModel>(new UICellModel(this));
        _uiCells_p->initialModel(_mcore_p);
        _engine->rootContext()->setContextProperty("uiCellModel", &(*this->getUICellModel()));
        bool connected1 = QObject::connect(&(*_uiCells_p), SIGNAL(clickCellSignal(quint32)), &(*this), SLOT(cellClickedSlot(quint32)));
        if (connected1) {
            qDebug() << "clickCellSignal->cellClickedSlot connected!";
        } else {
            qDebug() << "ERROR!!!!!!!!!!!!! clickCellSignal->cellClickedSlot DONT connected!";
        }
        bool connected2 = QObject::connect(&(*_uiCells_p), SIGNAL(setFlagSignal(quint32)),   &(*this), SLOT(cellSetFlagSlot(quint32)));
        if (connected2) {
            qDebug() << "setFlagSignal->cellSetFlagSlot connected!";
        } else {
            qDebug() << "ERROR!!!!!!!!!!!!! setFlagSignal->cellSetFlagSlot DONT connected!";
        }

        _vboolOpenedField.resize(_mcore_p->getCells().size());
        _vboolFlagField.resize(_mcore_p->getCells().size());
        for (auto i : _vboolOpenedField) i = false;
        for (auto i : _vboolFlagField) i = false;
        // create control buttons
        QSharedPointer<UIButtonHandler> uiButtonHandler_p{new UIButtonHandler()};
        // Q_ASSERT(QObject::connect(this,
        _uiCells_p->updateData(_mcore_p);
        _uiCells_p->reloadData();
        qDebug() << "!!!game ready!!!";
        emit gameReady();
    }

signals:
    void gameReady();
    void flagSettedChanged();
    void scoreChanged();
    void totalMinesChanged();
    void youWin();
    void youLose();

private:
    RevealResult _baseClick(quint32 index) {
        qDebug() << "\n_baseClick:";
        RevealResult rr = _mcore_p->revealCell(index);
        switch(rr) {
        case RevealResult::InvalidMove:
            qDebug() << "InvalidMove";
            break;
        case RevealResult::AlreadyRevealed:
            qDebug() << "AlreadyRevealed";
            break;
        case RevealResult::Bomb:
            qDebug() << "Bomb";
            emit youLose();
            break;
        case RevealResult::Safe:
            qDebug() << "Safe";
            updateUserStatus();
            break;
        }
        _uiCells_p->updateData(_mcore_p);
        return rr;
    }

private:
    QQuickView*                   _engine = nullptr;
    QSharedPointer<MinefieldCore> _mcore_p;
    QSharedPointer<UICellModel>   _uiCells_p;
    QSharedPointer<GameSettings>  _gameSettings_p;
    bool                          _firstClick = true;

    qint32                        _flagSetted = 0;
    qint32                        _bombFinded = 0;
    qint32                        _cellOpened = 0;
    qint32                        _score      = 0;
    std::vector<bool>             _vboolOpenedField;
    std::vector<bool>             _vboolFlagField;

    bool                          _isWin = false;
};

}

#endif // GAMESTATE_H
