/* 
* @Author: thomasvogelpohl
* @Date:   2015-12-14 16:39:40
* @Last Modified by:   Thomas Vogelpohl
* @Last Modified time: 2016-05-18 10:29:50
*/

import QtQuick 2.6
import Box2DStatic 2.0
import "../shared"

Item {
    id: trackJointAngleScreen
    width: 800
    height: 600
    focus: true

    property bool enableTracking: false
    property real requestedAngle: 0

    Keys.onPressed: {
        if (event.key === Qt.Key_Left) {
        	console.log("Key left")
            revolute.motorSpeed -= 10;
        }
        else if (event.key === Qt.Key_Right) {
        	console.log("Key right")
            revolute.motorSpeed += 10
        }
	    else if (event.key === Qt.Key_Up) {
	    	console.log("Key up")
	    	revolute.enableMotor = true
		    revolute.maxMotorTorque = 200
		    enableTracking = true
	    }
		else if (event.key === Qt.Key_Down) {
			console.log("Key down")
		    revolute.enableMotor = false
		    enableTracking = false
		}
        event.accepted = true;
    }

    Text {
        id: helpText
        anchors {
            right: parent.right
            top: parent.top
            left: parent.left
        }
        height: 40
        horizontalAlignment: Text.AlignHCenter;
        text: "Mouse click to set new tracking point (if motor active)"
    }

    Text {
        id: angleText
        x: ((trackJointAngleScreen.width / 2) - (angleText.implicitWidth /2))
        y: 50
        horizontalAlignment: Text.AlignHCenter

        text: "Angle: " + requestedAngle.toFixed(0)
        font.pixelSize: 16
        font.bold: true
    }

    // BOX2D WORLD
    World { 
    	id: physicsWorld

    	onStepped: {
    		if(enableTracking) {
	    		var targetAngle = trackJointAngleScreen.requestedAngle
	    		var angleError = revolute.getJointAngle() - targetAngle
	    		var gain = 1.4;
	    		var newMotorSpeed = -gain * angleError

	    		revolute.motorSpeed = newMotorSpeed
	    	}
    	}
	}

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


    MouseArea {
        anchors.fill: parent
        onClicked: {
            var radTodeg = 57.295779513082320876
            var bodyAPosition = Qt.vector2d(middle.x, middle.y)
            var localAnchorRevolute = Qt.vector2d(revolute.localAnchorA.x, revolute.localAnchorA.y);
            var globalPositionRevolute = bodyAPosition.plus(localAnchorRevolute)
            var mousePosition = Qt.vector2d(mouseX, mouseY);
            var differenceVector = mousePosition.minus(globalPositionRevolute);

            trackJointAngleScreen.requestedAngle = Math.atan2(differenceVector.y, differenceVector.x) * radTodeg
        }
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
        id: upButton
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
                revolute.maxMotorTorque = 200
                enableTracking = true
            }
        }
    }

    Rectangle {
        id: downButton
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
                enableTracking = false
            }
        }
    }
}
