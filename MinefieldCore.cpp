#include <QVector>
#include <QString>
#include <random>
#include <algorithm>
#include <QSet>
#include <QStack>

#include <array>

#include "MinefieldCore.h"

namespace minesweeper {

// ---------> constructors
MinefieldCore::MinefieldCore(quint16 height, quint16 width, quint32 countMines) :
    _height(height), _width(width), _countMines(countMines) {

    if (1 > _height)                    throw EMinefieldInitialization("height must be at least 1. given: " + QString::number(_height));
    if (1 > _width)                     throw EMinefieldInitialization("width must be at least 1. given: " + QString::number(_width));
    if (0 > _countMines)                throw EMinefieldInitialization("count mines must be at least 0. given: " + QString::number(_countMines));
    if (_height * _width < _countMines) throw EMinefieldInitialization("count mines must be at least than field square (height * width = "
                                       + QString::number(_height * _width) + "). given: " + QString::number(_countMines));

    _cells.resize(_height * _width);
    for (quint64 i = 0; i < _countMines; ++i)
        _cells[i].value = BOMB_VALUE;
}

// ---------> public methods
void MinefieldCore::shuffleMines() {
    std::random_device rd;
    std::mt19937 gen(rd());

    QSet<quint32> setIndex;
    for (quint32 i = _cells.size() - 1; i > 0; --i) {
        std::uniform_int_distribution<size_t> dist(0, i);
        size_t random_index = dist(gen);
        qSwap(_cells[random_index], _cells[i]);
        setIndex.insert(random_index);
        setIndex.insert(i);
    }

    for (auto i : setIndex) {
        _changedCells.insert(i);
    }
}
void MinefieldCore::pureStart(quint32 index) { // bug: if bomb will be shuffled, used do not see it (field donot updated)
    if (index > _cells.size())
        throw EIndexOutOfRange("index: " + QString::number(index) + " is out of range");

    if (BOMB_VALUE != _cells[index].value)
        return;

    bool ensured_pure_start = false;
    for (quint64 i = 0; i < _cells.size(); ++i) {
        if (i == index)
            continue;

        if (BOMB_VALUE != _cells[i].value) {
            qSwap(_cells[i], _cells[index]);
            ensured_pure_start = true;
            break;
        }
    }

    if (!ensured_pure_start)
        throw EInvalidPureStart();
}
void MinefieldCore::assignMineHints() {
    for (quint64 i = 0; i < _cells.size(); ++i)
        if (BOMB_VALUE != _cells[i].value)
            _cells[i].value = minesAround(i);
}
quint8 MinefieldCore::minesAround(quint32 index) const {
    quint8 count_mines = 0;

    for (quint64 i = 0; i < _MOORE_NEIGHBORS; ++i) {
        qint16 curr_y = index / _width + _dy[i];
        qint16 curr_x = index % _width + _dx[i];

        if (_isValidPos(curr_x, curr_y) && _isMine(curr_x, curr_y))
            count_mines++;
    }

    return count_mines;
}
RevealResult MinefieldCore::revealCell(quint32 index) {
    if (index > _cells.size())
        throw EIndexOutOfRange("index: " + QString::number(index) + " is out of range");

    _changedCells.insert(index);

    if (_cells[index].hasFlag)
        return RevealResult::InvalidMove;
    else if (_cells[index].isRevealed) {
        return _openRevealedArea(index);
    }
    else if (BOMB_VALUE == _cells[index].value) {
        _cells[index].isRevealed = true;
        return RevealResult::Bomb;
    }

    _openArea(index);
    return RevealResult::Safe;
}
void MinefieldCore::setFlag(quint32 index) { _cells[index].hasFlag = true; _changedCells.insert(index); }
void MinefieldCore::removeFlag(quint32 index) { _cells[index].hasFlag = false; _changedCells.insert(index); }
void MinefieldCore::changeFlag(quint32 index) {  if (!_cells[index].isRevealed) _cells[index].hasFlag = !_cells[index].hasFlag; _changedCells.insert(index); }
quint16 MinefieldCore::getHeight() const { return _height; }
quint16 MinefieldCore::getWidth() const { return _width; }
const QVector<Cell>& MinefieldCore::getCells() const { return _cells; }
const QSet<quint32>& MinefieldCore::getChangedIndex() {
    return _changedCells;
}
bool MinefieldCore::emptyChange() const {
    return _changedCells.isEmpty();
}
void MinefieldCore::dataUpdated() {
    _changedCells.clear();
}

// ---------> private methods
void MinefieldCore::_openArea(quint32 index) { // may better call revealCell than check isRevealed property
    _cells[index].isRevealed = true;
    _changedCells.insert(index);

    if (0 == _cells[index].value) {
        _cells[index].isRevealed = true;

        for (quint64 i = 0; i < _MOORE_NEIGHBORS; ++i) {
            qint16 curr_y = index / _width + _dy[i];
            qint16 curr_x = index % _width + _dx[i];

            if (_isValidPos(curr_x, curr_y)) {
                if (0 == _cells[_ordsToIndex(curr_x, curr_y)].value && !_cells[_ordsToIndex(curr_x, curr_y)].isRevealed)
                    revealCell(_ordsToIndex(curr_x, curr_y));

                if (!_cells[_ordsToIndex(curr_x, curr_y)].hasFlag) {
                    _cells[_ordsToIndex(curr_x, curr_y)].isRevealed = true;
                    _changedCells.insert(_ordsToIndex(curr_x, curr_y));
                }
            }
        }
    }
}
RevealResult MinefieldCore::_openRevealedArea(quint32 index) {

    quint8 count_revealed_mines = 0;
    quint8 count_hidded_cells = 0; // for count mines that are hidden and not flagged

    for (quint64 i = 0; i < _MOORE_NEIGHBORS; ++i) {
        qint16 curr_y = index / _width + _dy[i];
        qint16 curr_x = index % _width + _dx[i];
        if (_isValidPos(curr_x, curr_y)) {
            if (_cells[_ordsToIndex(curr_x, curr_y)].hasFlag)
                count_revealed_mines++;
            if (!_cells[_ordsToIndex(curr_x, curr_y)].isRevealed)
                count_hidded_cells++;
        }
    }

    if (count_hidded_cells == minesAround(index)) {
        for (quint64 i = 0; i < _MOORE_NEIGHBORS; ++i) {
            qint16 curr_y = index / _width + _dy[i];
            qint16 curr_x = index % _width + _dx[i];
            if (_isValidPos(curr_x, curr_y) && !_cells[_ordsToIndex(curr_x, curr_y)].isRevealed) {
                _cells[_ordsToIndex(curr_x, curr_y)].hasFlag = true;
                _changedCells.insert(_ordsToIndex(curr_x, curr_y));
            }
        }
        return RevealResult::Safe;
    }

    if (count_revealed_mines == minesAround(index)) {
        for (quint64 i = 0; i < _MOORE_NEIGHBORS; ++i) {
            qint16 curr_y = index / _width + _dy[i];
            qint16 curr_x = index % _width + _dx[i];
            if (_isValidPos(curr_x, curr_y) && !_cells[_ordsToIndex(curr_x, curr_y)].hasFlag) {
                if (BOMB_VALUE == _cells[_ordsToIndex(curr_x, curr_y)].value) {
                    _cells[_ordsToIndex(curr_x, curr_y)].isRevealed = true;
                    _changedCells.insert(_ordsToIndex(curr_x, curr_y));
                    return RevealResult::Bomb;
                }
                _openArea(_ordsToIndex(curr_x, curr_y));
            }
        }
        return RevealResult::Safe;
    }

    return RevealResult::AlreadyRevealed;
}
bool MinefieldCore::_isValidPos(const qint16 x, const qint16 y) const {
    if (x < 0 || y < 0 || x >= _width || y >= _height) return false;
    else return true;
}
bool MinefieldCore::_isMine(const qint16 x, const qint16 y) const {
    return BOMB_VALUE == _cells[_ordsToIndex(x, y)].value;
}
quint32 MinefieldCore::_ordsToIndex(const qint16 x, const qint16 y) const {
    return y * _width + x;
}

}
