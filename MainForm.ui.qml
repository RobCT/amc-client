import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    anchors.fill: parent

    property alias button3: button3
    property alias button2: button2
    property alias button1: button1
    property alias tf1: textField1
    property alias tv1: tv1

    RowLayout {
        anchors.top: tv1.bottom

        Button {
            id: button1
            text: qsTr("Press Me 1")
        }

        Button {
            id: button2
            text: qsTr("Press Me 2")
        }

        Button {
            id: button3
            text: qsTr("Press Me 3")
        }
    }

    TableView {
        id: tv1
        x: 74
        y: 34
        width: parent.width
        height: parent.height*2/3


        TableViewColumn {
            role: "email"
            title: "email"

        }

    }

    TextField {
        id: textField1
        x: 74
        y: 229
        placeholderText: qsTr("Text Field")
    }
}
