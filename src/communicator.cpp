#include "communicator.h"

#include <QDebug>
#include <QJsonArray>
#include <QNetworkRequest>

Communicator::Communicator(QObject *parent) : QObject(parent)
{
    _naManager = new QNetworkAccessManager(this);

    connect(_naManager,&QNetworkAccessManager::finished,
            this,&Communicator::queryFinishedSlot);

    connect(_naManager,&QNetworkAccessManager::sslErrors,
            this,&Communicator::sslErrorSlot);

}

Communicator::~Communicator()
{

}

void Communicator::readCourseList()
{
    // https geht auch
    QUrl url("https://ux4.edvschule-plattling.de/kt/KlaTabService.php?SearchNach=Klasse");
    QNetworkRequest req(url);

    QString concatenated = "klatab:klatab";
    QByteArray data = concatenated.toLocal8Bit().toBase64();
    QString headerData = "Basic " + data;
    req.setRawHeader("Authorization", headerData.toLocal8Bit());


    _naManager->get(req);
	
	
	
//QNetworkRequest req(url);
// HTTP Basic authentication header value: base64(username:password)
//QString concatenated = "username:password";
//QByteArray data = concatenated.toLocal8Bit().toBase64();
//QString headerData = "Basic " + data;
//req.setRawHeader("Authorization", headerData.toLocal8Bit());
//QNetworkReply* ipReply = netManager->get(req);
}

void Communicator::queryFinishedSlot(QNetworkReply *r)
{
    if(r->error() != QNetworkReply::NoError) {
        qDebug() << r->errorString();
        r->deleteLater();
        return;
    }
    if(r == _nwReply) {
        qDebug() << "Antwort ist da";
        (void)_nwReply->readAll();
        return;
    }

    QByteArray result = r->readAll();
    r->deleteLater();

    qDebug() << result;

}

void Communicator::sslErrorSlot(QNetworkReply *r)
{
    r->ignoreSslErrors();
}

