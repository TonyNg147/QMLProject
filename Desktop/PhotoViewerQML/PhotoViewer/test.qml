import QtQuick 2.14
import Qt.labs.folderlistmodel 1.0
import QtQuick.Controls 2.14
import ModelData 1.0
ApplicationWindow{
    objectName: "pathViewContainer"
    width:700
    height:560
    visible:true
    id:pathViewContainer
    ImageModel{
        id:model
    }

    Rectangle{
        anchors.centerIn:parent
        color:'blue'
        height:100
        width:100
        Text{
            anchors.centerIn:parent
            text:model.count;
        }
        MouseArea{
            anchors.fill:parent
            onClicked: {
                console.log("Go")
                model.changeCount()
            }
        }
    }
}
