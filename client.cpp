#include "client.h"
#include <QDebug>

client::client(QObject *parent ):QObject (parent)
{
    connect_status = OFFLINE;
    sock = new QTcpSocket;
    connect(this->sock, SIGNAL(connected()), this, SLOT(set_connect_status()));
}

client::~client()
{
    if(connect_status)
    {
        sock->close();
        connect_status = OFFLINE;
    }

    if(sock != nullptr)
    {
        delete sock;
        sock = nullptr;
    }

}

client::SOCK_STAUS client::status() const
{
    qDebug("connect");
    return connect_status;
}

void client::set_status(const SOCK_STAUS &status)
{
    connect_status = status;
    qDebug("sat=%d",status);
    emit status_changed();
}

void client::set_connect_status()
{
    qDebug("connected");
    connect_status = ONLINE;
}

void client::connec_to_srv()
{
    sock->connectToHost("192.168.64.130", 5555);
}
