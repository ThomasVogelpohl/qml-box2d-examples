import QtQuick 2.0
import Box2DStatic 2.0
import "../shared"

Item {
    id: screen
    width: 800
    height: 600
    focus: true

    Keys.onPressed: {
        if (event.key === Qt.Key_Left) {
            revolute.motorSpeed -= 10;
        }
        else if (event.key === Qt.Key_Right) {
            revolute.motorSpeed += 10
        }
        event.accepted = true;
    }

    // BOX2D WORLD
    World { id: physicsWorld }

    PhysicsItem {
        id: rod

        sleepingAllowed: false
        bodyType: Body.Dynamic
        x: 350
        y: 300

        width: 250
        height: 40

        fixtures: Box {
            width: rod.width
            height: rod.height
            density: 1;
            friction: 1;
            restitution: 0.3;
        }

        Rectangle {
            color: "green"
            radius: 6
            anchors.fill: parent
        }
    }

    PhysicsItem {
        id: middle

        x: 400
        y: 300

        fixtures: Circle { radius: itemShape.radius }

        Rectangle {
            id: itemShape
            radius: width / 2
            width: 40; height: 40
            color: "black"
        }
    }

    RevoluteJoint {
        id: revolute
        maxMotorTorque: 1000
        motorSpeed: 0
        enableMotor: false
        bodyA: middle.body
        bodyB: rod.body
        localAnchorA: Qt.point(20,20)
    }

    // Debug
    DebugDraw {
        id: debugDraw
        world: physicsWorld
        opacity: 0.5
        visible: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: revolute.enableMotor = !revolute.enableMotor
    }


    Text {
        id: motorText
        x: 50
        y: 50
        horizontalAlignment: Text.AlignHCenter

        text: "Motor: " + ((revolute.enableMotor === true) ? "on" : "off")
        font.pixelSize: 16
        font.bold: false
    }


    Rectangle {
        id: onButton
        x: 50
        y: 90
        width: 50
        height: 50
        Text {
            id: upButtonText
            text: "on"
            anchors.centerIn: parent
        }
        color: "#DEDEDE"
        border.color: "#999"
        radius: 5
        MouseArea {
            acceptedButtons: Qt.LeftButton
            anchors.fill: parent
            propagateComposedEvents: false
            onPressed: {
                revolute.enableMotor = true
            }
        }
    }

    Rectangle {
        id: offButton
        x: 110
        y: 90
        width: 50
        height: 50
        Text {
            id: downButtonText
            text: "off"
            anchors.centerIn: parent
        }
        color: "#DEDEDE"
        border.color: "#999"
        radius: 5
        MouseArea {
            acceptedButtons: Qt.LeftButton
            anchors.fill: parent
            propagateComposedEvents: false
            onPressed: {
                revolute.enableMotor = false
            }
        }
    }


    Text {
        id: motorSpeed
        x: 50
        y: 180
        horizontalAlignment: Text.AlignHCenter

        text: "Motorspeed: " + revolute.motorSpeed
        font.pixelSize: 16
        font.bold: false
    }


    Rectangle {
        id: speedDownButton
        x: 50
        y: 220
        width: 50
        height: 50
        Text {
            text: "-"
            anchors.centerIn: parent
        }
        color: "#DEDEDE"
        border.color: "#999"
        radius: 5
        MouseArea {
            acceptedButtons: Qt.LeftButton
            anchors.fill: parent
            propagateComposedEvents: false
            onPressed: {
                revolute.motorSpeed -= 10
            }
        }
    }

    Rectangle {
        id: speedUpButton
        x: 110
        y: 220
        width: 50
        height: 50
        Text {
            text: "+"
            anchors.centerIn: parent
        }
        color: "#DEDEDE"
        border.color: "#999"
        radius: 5
        MouseArea {
            acceptedButtons: Qt.LeftButton
            anchors.fill: parent
            propagateComposedEvents: false
            onPressed: {
                revolute.motorSpeed += 10
            }
        }
    }    
}
