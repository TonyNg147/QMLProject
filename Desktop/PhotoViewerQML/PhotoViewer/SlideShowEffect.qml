import QtQuick 2.0
import QtQml 2.12
import QtQuick.Controls 2.5
import Qt.labs.folderlistmodel 1.0
import ModelData 1.0
import Controller 1.0
Page{
    objectName: "slideShowEffect"
    Item{

        id:idControl
        anchors.fill:parent
        property int duration:3000
        property int fadeSpeed:1000
        property var model:fileModel
        QtObject{
            id:internalControl
            property int currentIndex:0
            property int nextIndex:1
            property bool ab:true
            // cannot use this event to set front.source, because we need to let it return into "0" opacity state
            //before changing the source Image. This allows the animated slide Show goes smoother
            onCurrentIndexChanged: {
                if (front.opacity===1)
                {
                    back.source = idControl.model.get(currentIndex,ImageModel.SourceRole)
                }
            }
        }
        Image{
            id:back
            source:idControl.model.get(1,ImageModel.SourceRole)
            anchors.fill:parent
        }
        Image{
            id:front
            source:idControl.model.get(0,ImageModel.SourceRole)
            anchors.fill:parent
            opacity:internalControl.ab?1:0
            Behavior on opacity {
                NumberAnimation{duration:idControl.fadeSpeed}
            }
            onOpacityChanged: {
                if (opacity ===0 )
                {
                    front.source = idControl.model.get(internalControl.nextIndex,ImageModel.SourceRole)
                }
            }
        }

        MyTimer{
            id:myTimer
            count:fileModel.count
            Component.onCompleted: {
                console.log(count)
            }

            onDueTime: {
               internalControl.ab = !internalControl.ab;
                internalControl.currentIndex=pre;
                internalControl.nextIndex=post;
            }
        }
        Component.onCompleted: {
            console.log("Component completed");
            myTimer.start();
        }
        Component.onDestruction: {
            myTimer.stop();
            console.log("Destruct")
        }

    }
}


