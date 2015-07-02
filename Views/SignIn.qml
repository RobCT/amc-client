import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "../controllers" as Cont
import "../scripts/globals.js" as G
Rectangle {
    id: rectangle1
    width: parent.width
    height: parent.height
    color: "beige"

    Grid {
        id: g1
        y: parent.height/6
        width: parent.width/3
        x: parent.width/6

        columns: 2
        rows: 6
        columnSpacing: parent.width/10
        rowSpacing: parent.height/20
        Text {text: "Your user name"}
        TextField {
            id: username
            width: parent.width/2
            placeholderText: qsTr("your username")

        }
        Text {text: "Your email"}
        TextField {
            id: email
            width: parent.width/2
            placeholderText: qsTr("your email")

        }


        Text {text: "Your password"}
        TextField {
            id: password
            echoMode: TextInput.PasswordEchoOnEdit
            width: parent.width/2
            placeholderText: qsTr("your password")

        }
        Text {
            id: txtCp
            visible: false
            text: "Confirm password"
        }
        TextField {
            id: passwordConfirm
            visible: false
            echoMode: TextInput.PasswordEchoOnEdit
            width: parent.width/2
            placeholderText: qsTr("confirm password")

        }
        Button {
            id: register
            text: "Click to register"
            onClicked: {
                txtCp.visible=true
                passwordConfirm.visible=true
                signin.text = "Register"
            }
       }
        Button {
            id: signin
            text: "Sign In"
            onClicked: {
                if (passwordConfirm.visible) {
                    txtCp.visible=false
                    passwordConfirm.visible=false
                    signin.text = "Sign In"
                    entry.signin.currentPassword = password.text
                    users.newUser(JSON.stringify({"user":{"username": username.text,   "email": email.text, "password": password.text, "password_confirmation": passwordConfirm.text}}))
                    email.text = ""
                    password.text = ""
                    passwordConfirm.text = ""

                }
                else {
                    entry.signin.currentPassword = password.text
                    if (username.text.length)
                        session.newSession(JSON.stringify({"username": username.text, "password": password.text}))
                    else
                       session.newSession(JSON.stringify({"email": email.text, "password": password.text}))
                    //console.log(entry.signin.id)


            }

        }
        }



        Button {
            id: logout
            text: "Logout"
            onClicked: {

                    session.destroySession(entry.signin.auth_token)
                    entry.signin.signedin = false

                   //console.log(JSON.stringify(entry.signin.auth_token))



        }

        }

        TextArea {
            id:fetchStatus

        }

        Component.onCompleted:  {
            username.text = entry.signin.userName
            email.text = entry.signin.currentEmail
            password.text = entry.signin.currentPassword
        }
    }
    Cont.UserController {
        id: users
        onReadyChanged: {
            //console.log("return",jsn, status)
            if (status != 201) {
                fetchStatus.append(jsn)
            }
        }

    }
    Cont.SessionController {
        id: session
        onReadyChanged: {

                if (status == 200) {
                    entry.signin.auth_token = tok.auth_token
                    entry.signin.currentEmail = tok.email
                    entry.signin.userName = tok.username
                    entry.signin.signedin = true
                    entry.signin.id = tok.id
                   //console.log("id", tok.id)
                    G.token = tok.auth_token
                    sockserver.getSocketServer()
                    entry.pushOther(1)
                   //console.log(entry.signin.auth_token,entry.signin.currentEmail, entry.signin.userName)
                }
                if (status == 204) {
                    entry.pushOther(1)

                }
                if (status == 422) {
                    fetchStatus.text = "Sorry that email or password is not accepted"
                   //console.log("Sorry that email or password is not accepted")
                }





        }



    }
    Cont.SocketServerController {
        id: sockserver
    }
}

