#ifndef UICELLMODEL_H
#define UICELLMODEL_H

#include <QObject>
#include <QVector>
#include <QHash>
#include <QAbstractListModel>
#include <QWeakPointer>
#include <QSharedPointer>
#include <QScopedPointer>
#include <QSet>
#include <QDebug>
#include <QCoreApplication>

#include "MinefieldCore.h"
#include "GameSettings.h"
#include "EMinesweeper.h"
#include "PerlinNoise.h"

#include <chrono>

namespace minesweeper {

using qsizetype = std::size_t;

struct UICell {
    const Cell* logicCell; //////////////////////////////////////////////////////////////////////////////////// try use const pointer
    qsizetype texture;
};

class UICellModel : public QAbstractListModel {

    Q_OBJECT

public:
    enum CellRole {
        Value = Qt::UserRole + 1,
        HasFlag,
        IsRevealed,
        Texture
    };

    UICellModel(QObject* qobj_p = nullptr) : QAbstractListModel(qobj_p) {}

    void reloadData() {
        auto start_time = std::chrono::steady_clock::now();
        beginResetModel();
        qDebug() << "data was reloaded" << _uiCells[0].logicCell->value;
        endResetModel();
        auto end_time = std::chrono::steady_clock::now();
        qDebug() << "--] TIME [-- reloadData :" << std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count() << "ms";
    }
    void updateCell(const quint32 cellsIndex) {
        QModelIndex modelIndex = this->index(cellsIndex);
        emit dataChanged(modelIndex, modelIndex, {Value, HasFlag, IsRevealed, Texture});
    }
    void initialModel(QSharedPointer<MinefieldCore> mcore_p) {
        const QVector<Cell>& qvec = mcore_p->getCells();
        _uiCells.resize(qvec.size());

        for (qsizetype i = 0; i < _uiCells.size(); ++i) {
            _uiCells[i].logicCell = &qvec[i];
        }

        // generate map
        PerlinNoise noise;
        quint32 octave = 5;
        float persistence = 0.5;
        float multiply = 100;
        quint32 width  = mcore_p->getWidth();
        quint32 height = mcore_p->getHeight();

        for (qsizetype i = 0; i < _uiCells.size(); ++i) {
            float n = noise.Noise(width * multiply / (1 + i / width), height * multiply / (1 + i % width), octave, persistence);
            _uiCells[i].texture = qAbs(PerlinNoise::discretize(n, 10));
        }

        qDebug() << "ui model initial. loaded " << mcore_p->getCells().size() << " elements";
    }
    int rowCount(const QModelIndex& parent = QModelIndex()) const override {
        return _uiCells.size();
    }
    QVariant data(const QModelIndex& index, int role) const override {
        if (!index.isValid())
            return QVariant();

        switch(CellRole(role)) {
        case CellRole::Value:
            return _uiCells[index.row()].logicCell->value;
        case CellRole::HasFlag:
            return _uiCells[index.row()].logicCell->hasFlag;
        case CellRole::IsRevealed:
            return _uiCells[index.row()].logicCell->isRevealed;
        case CellRole::Texture:
            return static_cast<int>(_uiCells[index.row()].texture);
        default:
            return QVariant();
        }
    }
    void updateData(QSharedPointer<MinefieldCore> mcore_p) {
        auto start_time = std::chrono::steady_clock::now();
        int count = 0;
        QSet<const quint32> index_set;
        if (!mcore_p->emptyChange()) {
            auto set = mcore_p->getChangedIndex();
            for (auto i : set) {
                updateCell(i);
                index_set.insert(i);
                count++;
            }
        }
        mcore_p->dataUpdated();
        auto end_time = std::chrono::steady_clock::now();
        qDebug() << "--] TIME [-- updateData :" << std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count() << "ms";
        qDebug() << "updated cell:" << count << "from requared update:" << index_set.count();
    }

    Q_INVOKABLE void clickCell(quint32 index) {
        qDebug() << "signal clicked cell from" << index << "sended";
        emit clickCellSignal(index);
    }
    Q_INVOKABLE void setFlagCell(quint32 index) {
        emit setFlagSignal(index);
    }

signals:
    void clickCellSignal(quint32);
    void setFlagSignal(quint32);

public:
    QHash<int, QByteArray> roleNames() const override {
        return {
            { CellRole::Value,      "value" },
            { CellRole::HasFlag,    "hasFlag" },
            { CellRole::IsRevealed, "isRevealed" },
            { CellRole::Texture,    "texture" }
        };
    }

private:
    QVector<UICell> _uiCells;
};



}

#endif // UICELLMODEL_H
