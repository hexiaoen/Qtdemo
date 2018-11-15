import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.1
import he.qt.client 1.0

Window   {
    id:father
    visible: true
    width: 640
    height: 480
    title: qsTr("CHAT")

    property real brw: father.width/640
    property real brh: father.height/480


    function rw(num)
    {
        return num*brw
    }

    function rh(num)
    {
        return num * brh
    }

    Client
    {
        id:peer
    }

    Text
    {
        id: status
        text: "login please"
        //anchors.centerIn: parent
        //anchors.horizontalCenterOffset: 0
        //anchors.verticalCenterOffset: -200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:parent.top
        anchors.topMargin: rh(20)
    }


    function status_action(action)
    {
        if(action === "ONLINE")
        {
            status.text= qsTr("ONLINE")

            send_btn.enabled = true
            disconnect_btn.enabled = true
            connect_btn.enabled = false

            recv_display.visible = true
            input_edit.visible = true
            srv_ip.visible = false
        }
        else if(action === "connecting")
        {
            status.text= qsTr("connecting...")

            send_btn.enabled = false
            disconnect_btn.enabled = true
            connect_btn.enabled = false

            recv_display.visible = false
            input_edit.visible = false
            srv_ip.visible = true
            srv_ip.readOnly = true
        }
        else if(action === "OFFLINE")
        {
            status.text= qsTr("OFFLINE")

            send_btn.enabled = false
            disconnect_btn.enabled = false
            connect_btn.enabled = true

            recv_display.visible = false
            rte.text = ""
            input_edit.visible = false
            srv_ip.visible = true
            srv_ip.readOnly = false
        }
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
                status_action("ONLINE")
            }
            else if (peer_status === 2)
            {
                status_action("connecting")
            }
            else if (peer_status === 0)
            {
                status_action("OFFLINE")
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
        anchors.leftMargin: rw(15)
        anchors.top:input_edit.bottom
        anchors.topMargin: rh(20)

        width: rw(140)
        height: rh(50)


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
        anchors.rightMargin: rw(15)
        anchors.top:input_edit.bottom
        anchors.topMargin: rh(20)

        width: rw(140)
        height: rh(50)

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
        anchors.topMargin: rh(20)

        width: rw(140)
        height: rh(50)

        text: qsTr("connect")
        onClicked:

        {
            peer.connec_to_srv(srv_ip.text)

        }
    }

    Rectangle {
        id: recv_display

        anchors.horizontalCenter: status.horizontalCenter
        anchors.top:status.bottom
        anchors.topMargin: rh(20)

        width:  rw(460)
        height: rh(120)

        visible: false

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
        anchors.topMargin: rh(10)

        width:  rw(460)
        height: rh(100)
        visible: false


        border.color: "gray"
        TextEdit
        {
            id: ite
            anchors.fill: parent
        }
    }

    TextField
    {
        id: srv_ip

        inputMask: "000.000.000.000"

        text:"192.168.2.40"

        anchors.horizontalCenter: status.horizontalCenter
        anchors.top: status.bottom
        anchors.topMargin: rh(200)

    }
}
