#ifndef MINEFIELDCORE_H
#define MINEFIELDCORE_H

#include <QVector>
#include <QString>
#include <QSet>
#include <QHash>

#include <array>

#include "EMinesweeper.h"

namespace minesweeper {

constexpr const quint8 BOMB_VALUE = 9;
struct Cell {
    quint8 value = 0;
    bool hasFlag = false;
    bool isRevealed = false;
};

enum class RevealResult {
    InvalidMove,     // there is a flag in the cell
    AlreadyRevealed, // the cell was aldeary open
    Bomb,            // there is a bomb in an open cell
    Safe             // normal cell opening
};

class MinefieldCore {

public:
    explicit MinefieldCore(quint16 height, quint16 width, quint32 countMines);

    // use the Fisher-Yates algorithm to shuffle mines in the _cells in time O(n)
    void shuffleMines();

    // Guarantees a safe first move by relocating a mine if the selected cell contains one.
    void pureStart(quint32 index);

    // set property value for all cells
    void assignMineHints();

    // return the number of mines in the Moore area
    quint8 minesAround(quint32 index) const;

    RevealResult revealCell(quint32 index);
    void setFlag(quint32 index);
    void removeFlag(quint32 index);
    void changeFlag(quint32 index);
    quint16 getHeight() const;
    quint16 getWidth() const;
    const QVector<Cell>& getCells() const;

    const QSet<quint32>& getChangedIndex();
    bool emptyChange() const;
    void dataUpdated(); // clean _changedCells

private:
    // with auto open "zero" sectors
    void _openArea(quint32 index);

    // auto open area marked with flags
    RevealResult _openRevealedArea(quint32 index);

    bool _isValidPos(const qint16 x, const qint16 y) const;
    bool _isMine(const qint16 x, const qint16 y) const;
    quint32 _ordsToIndex(const qint16 x, const qint16 y) const;

private:
    QVector<Cell>   _cells;
    quint16         _height;
    quint16         _width;
    quint32         _countMines;
    QSet<quint32>   _changedCells; // collect changed index

private:
    // Moore area constant
    const quint64 _MOORE_NEIGHBORS = 8;
    const std::array<qint16, 8> _dy{ -1, -1, -1,  0, 1, 1,  1,  0 };
    const std::array<qint16, 8> _dx{ -1,  0,  1,  1, 1, 0, -1, -1 };
};

}
#endif // MINEFIELDCORE_H
