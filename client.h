#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QByteArray>



class client: public QObject
{
    Q_OBJECT
    Q_ENUMS(SOCK_STAUS)  //申明在QML中可用


    Q_PROPERTY(SOCK_STAUS connect_status READ status WRITE set_status NOTIFY status_changed) //申明该成员对QML可见
public:
    explicit  client(QObject *parent = nullptr);
    ~client();

    Q_INVOKABLE void connec_to_srv(QString srv_ip);
    Q_INVOKABLE void disconnect_from_srv();
    Q_INVOKABLE void msg_send(QString data);

    enum SOCK_STAUS
    {
        OFFLINE = 0,
        ONLINE,
        ONPROCESS
    };


    SOCK_STAUS status() const;


public slots:
    void set_status(const SOCK_STAUS &status);
    void set_connect_status();
    void msg_handle();

signals:
    void status_changed();
    void msg_rcv(QByteArray data);

private:
    QByteArray buf;
    SOCK_STAUS connect_status;
    QTcpSocket *sock;
};

#endif // CLIENT_H
