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

        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 0
        anchors.verticalCenterOffset: -200

    }

    Connections
    {
        target: peer
        onStatus_changed:
        {
            //status.text=qsTr("status change")
            status.text=  peer.connect_status?("connect"):("disconnect")
            console.log(peer.connect_status)

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
        onClicked:
        {
            console.log("send click")
        }
    }

    Button
    {
        id:disconnect_btn
        anchors.horizontalCenter: input_edit.horizontalCenter
        anchors.top:input_edit.bottom
        anchors.topMargin: 30
        text: "disconnect"
        onClicked:
        {
            status.text = "offline"
            console.log(" disconnected")
        }
    }

    Button {
        id: connect_btn
        anchors.right: input_edit.right
        anchors.rightMargin: 15
        anchors.top:input_edit.bottom
        anchors.topMargin: 30
        text: qsTr("connect")
        onClicked:
        {
            status.text = "conneting..."
            peer.connec_to_srv();
            peer.set_status(peer.ONLINE)
        }
    }

    TextField {
        id: recv_display
        anchors.horizontalCenter: status.horizontalCenter
        anchors.top:status.bottom
        anchors.topMargin: 20
        width: 330
        height: 156
        font.pixelSize: 12
        verticalAlignment:AlignTop  //字体左上对其
    }

    TextField {
        id: input_edit
        anchors.horizontalCenter: status.horizontalCenter
        anchors.top:recv_display.bottom
        anchors.topMargin: 20
        width: 330
        height: 86
        font.pixelSize: 12
        verticalAlignment:AlignTop
    }
}
