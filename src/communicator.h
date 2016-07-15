#ifndef COMMUNICATOR_H
#define COMMUNICATOR_H

#include <QObject>

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class Communicator : public QObject
{
    Q_OBJECT
public:
    explicit Communicator(QObject *parent = 0);
    ~Communicator();
signals:

 public slots:
    void readCourseList();

 private slots:
    void queryFinishedSlot(QNetworkReply *);
    void sslErrorSlot(QNetworkReply *);

 private:
    QNetworkAccessManager *_naManager;
    QNetworkReply         *_nwReply;
};

#endif // COMMUNICATOR_H
