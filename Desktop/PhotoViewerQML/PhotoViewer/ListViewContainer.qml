import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0
import QtQuick.Controls 2.14
Page{
    objectName: "listViewContainer"
    width:root.width
    height:root.height
    visible:true
    Rectangle{
        id:listViewContainer
        height:parent.height;width:parent.width
        clip:true
        ListView{
            id:listView
            ScrollBar.vertical: ScrollBar{
                hoverEnabled:true
                active:hovered|pressed
                anchors{right:parent.right;bottom:parent.bottom;top:parent.top}
                parent:listView
                //policy:ScrollBar.AlwaysOn
                snapMode:ScrollBar.SnapOnRelease
            }
            anchors.fill:parent
            anchors{
                leftMargin:20
                rightMargin:20
            }

//            Image{
//                id:listViewItemImage
//                fillMode:Image.PreserveAspectCrop
//                x:20;y:20
//                width:128;height:128
//                source:model.source
//            }
            //MouseArea{anchors.fill:parent;onClicked:maximizeImage(listViewItemImage,filePath,index)
            model:fileModel
            delegate:SwipeDelegate {
                id: swipeDelegate
                Text{
                    text: filePath
                    anchors{
                        left:listViewItemImage.right
                        leftMargin:30
                        verticalCenter: parent.verticalCenter
                    }

                    font.pointSize: 18
                }
                Image{
                    anchors{left:parent.left;verticalCenter: parent.verticalCenter}
                    source:model.source
                    width:128;height:128
                    anchors{left:parent.left;leftMargin:20}
                    id:listViewItemImage
                    MouseArea{
                        anchors.fill:parent;
                        onClicked: {
                            maximizeImage(listViewItemImage,filePath,index)
                        }
                    }
                }
                Image{
                    source:"qrc:/ButtonImages/TrashBin.png"
                    id:imageRemove
                    height:32;width:32
                    anchors{
                        right:parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: 30
                    }
                    MouseArea{
                        anchors.fill:parent
                        onClicked: {
                            dataForModel.removeItem(index)
                        }
                    }
                }

                width: parent.width
                height:160
                ListView.onRemove: SequentialAnimation {
                    PropertyAction {
                        target: swipeDelegate
                        property: "ListView.delayRemove"
                        value: true
                    }
                    NumberAnimation {
                        target: swipeDelegate
                        property: "height"
                        to: 0
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAction {
                        target: swipeDelegate
                        property: "ListView.delayRemove"
                        value: false
                    }
                }

                swipe.right: Label {
                    id: deleteLabel
                    text: qsTr("Delete")
                    font.pointSize: 18
                    font.bold:true
                    color: "white"
                    verticalAlignment: Label.AlignVCenter
                    padding: 12
                    height: parent.height
                    anchors.right: parent.right

                    SwipeDelegate.onClicked: listView.model.remove(index)

                    background: Rectangle {
                        color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("#00e600", 1.5) : "#00e600"
                    }
                    }
                }
            }


    }
}


