import QtQuick 2.4
import QtQuick.Controls 1.3


import "../scripts/servReq.js" as F
import "../scripts/globals.js" as G
import "../scripts/moment.js" as D
import "." as L
import Qt.WebSockets 1.0

Item{
        id: root
        property string token
        property real channel
        property bool newMessage: false
        property alias active: secureWebSocket.active
        property string username: subscribe.username
        property int room: -1
        property var message
        function getSocket() {
            secureWebSocket.active =false
            secureWebSocket.active = true
        }
        function closeSocket() {
            secureWebSocket.active =false
            subscribe.deleteSubscription(JSON.stringify({channel: root.channel}))
        }
        function sendMessage(msg) {

            var par = {auth_token: root.token, room: root.room, name: root.username, message: msg, created_at: D.moment(new Date()) }
            secureWebSocket.sendTextMessage(JSON.stringify(par))
            //console.log("send",G.socketServer,JSON.stringify(par))


        }


        WebSocket {
            id: secureWebSocket
            url: G.socketServer
            onTextMessageReceived: {
                var pp = JSON.parse(message)
                ////console.log(message)


                var mm = pp[0]
                if (typeof mm != "undefined") {
                    root.token = mm.auth_token
                    root.channel = mm.auth_ack
                    ////console.log("auth", mm.auth_token, mm.auth_ack)
                    secureWebSocket.sendTextMessage(JSON.stringify({auth_ack:mm.auth_ack, text: "ok"}))
                    if (root.room>0)
                    subscribe.newSubscription(JSON.stringify({room_id: root.room, channel: root.channel}))
                    else
                        subscribe.newSubscription(JSON.stringify({channel: root.channel}))
                }
                else {
                    root.message = pp
                    strobeNewMessage.start()

                }


                //messageBox.text = messageBox.text + "\nReceived message: " + pp.message + "    from " + pp.name
            }
            onStatusChanged: {
                ////console.log(socket.status)
                if (secureWebSocket.status == WebSocket.Error) {
                                 //console.log("Error: " + secureWebSocket.errorString)
                             } else if (secureWebSocket.status == WebSocket.Open) {
                                //console.log("open")
                                root.active = true
                            } else if (secureWebSocket.status == WebSocket.Closed) {
                                 root.active = false
                                //console.log("close")
                             }
            }
        }

        Timer {
            id: strobeNewMessage
              interval: 50; running: false; repeat: false
                onTriggered: {
                    if (!root.newMessage) {
                        root.newMessage = true
                        restart()
                   }
                    else root.newMessage = false
                }
        }
        L.SubscriptionController {
            id: subscribe

        }
        L.MessageController {
            id: messages
        }
    }



