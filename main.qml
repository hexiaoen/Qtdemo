import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.1
import he.qt.client 1.0

Window  {
    id:father
    visible: true
    width: 640
    height: 480

    Client
    {
        id:peer
    }

    Text
    {
        id: status
        text: "login please"
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 0
        anchors.verticalCenterOffset: -200

    }

    Connections
    {
        target: peer

        onStatus_changed:
        {

            var peer_status
            peer_status = peer.connect_status

            /*If use enum type SOCK_STAUS(like if(peer_status === peer.ONLINE)),
            the if codition can't work. I don't know why*/
            if(peer_status === 1)
            {
                status.text= qsTr("ONLINE")
                send_btn.enabled = true
                disconnect_btn.enabled = true
                connect_btn.enabled = false
            }
            else if (peer_status === 2)
            {
                status.text= qsTr("connecting...")
                send_btn.enabled = false
                disconnect_btn.enabled = true
                connect_btn.enabled = false
            }
            else if (peer_status === 0)
            {
                status.text= qsTr("OFFLINE")

                send_btn.enabled = false
                disconnect_btn.enabled = false
                connect_btn.enabled = true
            }

        }

        onMsg_rcv:
        {
            rte.text += data;
        }
    }


    Button
    {
        id: send_btn
        anchors.left: input_edit.left
        anchors.leftMargin: 15
        anchors.top:input_edit.bottom
        anchors.topMargin: 30
        text: "send"
        enabled:  false
        onClicked:
        {
            peer.msg_send(ite.text)
            ite.text = ""
        }
    }

    Button
    {
        id:disconnect_btn

        anchors.right: input_edit.right
        anchors.rightMargin: 15
        anchors.top:input_edit.bottom
        anchors.topMargin: 30

        text: "disconnect"
        enabled: false

        onClicked:
        {
            console.log(" disconnected")
            peer.disconnect_from_srv()
        }
    }

    Button {
        id: connect_btn

        anchors.horizontalCenter: input_edit.horizontalCenter
        anchors.top:input_edit.bottom
        anchors.topMargin: 30

        text: qsTr("connect")
        onClicked:

        {
            peer.connec_to_srv()

        }
    }

    Rectangle {
        id: recv_display

        anchors.horizontalCenter: status.horizontalCenter
        anchors.top:status.bottom
        anchors.topMargin: 20

        width: 330
        height: 156

        border.color: "gray"

        TextEdit
        {
            id: rte
            anchors.fill: parent
        }
    }

    Rectangle {
        id: input_edit

        anchors.horizontalCenter: status.horizontalCenter
        anchors.top:recv_display.bottom
        anchors.topMargin: 20

        width: 330
        height: 86

        border.color: "gray"
        TextEdit
        {
            id: ite
            anchors.fill: parent
        }
    }
}
