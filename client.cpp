#include "client.h"
#include <QDebug>


client::client(QObject *parent ):QObject (parent)
{
    connect_status = OFFLINE;
    sock = new QTcpSocket;
    connect(this->sock, SIGNAL(connected()), this, SLOT(set_connect_status()));
    connect(this->sock, SIGNAL(readyRead()), this, SLOT(msg_handle()));
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
    qDebug("read status");
    return connect_status;
}

void client::set_status(const SOCK_STAUS &status)
{
    if(connect_status == status)
        return ;

    connect_status = status;
    qDebug("sat=%d",status);
    emit status_changed();
}

void client::set_connect_status()
{
    qDebug("connected");
    set_status(ONLINE);
}

void client::connec_to_srv(QString srv_ip)
{
    if(status() == client::OFFLINE)
    {
        qDebug("connecting...");
        sock->connectToHost(srv_ip, 5555);
        set_status(ONPROCESS);
    }
}

void client::disconnect_from_srv()
{
    if(status() == client::OFFLINE)
        return ;

    sock->abort();
    set_status(OFFLINE);
    qDebug("disconnect");
}


void client::msg_handle()
{
    QByteArray buf = sock->readAll();
    emit msg_rcv(buf);
}

void client::msg_send(QString data)
{
    sock->write(data.toStdString().c_str());
}

