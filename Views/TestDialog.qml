import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Dialog {
    id: dateDialog
    visible: true
    modality: Qt.NonModal
    title: "Choose a date"
    standardButtons: StandardButton.Save | StandardButton.Cancel

   // onAccepted: console.log("Saving the date " )
        //calendar.selectedDate.toLocaleDateString())

    Rectangle {
        id: calendar

    }
}

