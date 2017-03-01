import QtQuick 2.0
import Box2DStatic 2.0
import "../shared"

Item {
    id: screen

    width: 800
    height: 600


    readonly property int wallMeasure: 32

    function xPos() {
        if (typeof xPos.min === 'undefined') {
        xPos.min = Math.ceil(wallMeasure)
        xPos.max = Math.floor(screen.width - wallMeasure)
        }
        return (Math.floor(Math.random() * (xPos.max - xPos.min)) + xPos.min)
    }


    World { id: physicsWorld; }

    Repeater {
        model: 10
        delegate: Trapezoid {
            x: xPos();
            y: Math.random() * (screen.height / 3);
            rotation: Math.random() * 90;
        }
    }

    ScreenBoundaries {}

    DebugDraw {
        world: physicsWorld
        opacity: 0.75
        visible: true
    }
}
