#ifndef EMINESWEEPER_H
#define EMINESWEEPER_H

#include <QException>

namespace minesweeper {

class EMinesweeper : protected QException {
public:
    EMinesweeper(QString msg = "") : _msg(msg) {}

    QString what() { return _msg; }

private:
    QString _msg;
};

class EMinefieldInitialization : public EMinesweeper {
public:
    EMinefieldInitialization(QString msg = "") : EMinesweeper(msg) {}
};

class EIndexOutOfRange : public EMinesweeper {
public:
    EIndexOutOfRange(QString msg = "") : EMinesweeper(msg) {}
};

class EInvalidPureStart : public EMinesweeper {};
class EInvalidUIInitialization : public EMinesweeper {
public:
    EInvalidUIInitialization(QString msg = "") : EMinesweeper(msg) {}
};

}

#endif // EMINESWEEPER_H
