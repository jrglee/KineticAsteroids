/* constants */
var MAX_SPEED = 5;
var DRAG = 0.005;
var BACKGROUND_SIZE_MULT = 1.5;
var SCREEN_WIDTH = window.innerWidth;
var SCREEN_HEIGHT = window.innerHeight;

$(document).ready(function() {
    $(document).keydown(function(e) {
        switch (e.keyCode) {
            case 37:
            case 65:
                // left arrow - a
                Ship.instance().turn(-10);
                break;
            case 38:
            case 87:
                // up arrow - w
                Ship.instance().accelerate(.5);
                break;
            case 39:
            case 68:
                // right arrow - d
                Ship.instance().turn(10);
                break;
            case 40:
            case 83:
                // down arrow - s
                Ship.instance().accelerate(-.5);
                break;
            case 32:
                // space bar - shoot
                Ship.instance().shoot();
                break;
        }

        e.preventDefault();
    });

    Asteroids.instance().start();
});

/* Singletons */
var Asteroids = (function() {
    var instantiated;

    function init() {
        var stage = new Kinetic.Stage("container", SCREEN_WIDTH, SCREEN_HEIGHT);

        // background
        var backgroundLayer = new Kinetic.Layer();
        backgroundLayer.add(new Kinetic.Rect({
            width: SCREEN_WIDTH,
            height: SCREEN_HEIGHT,
            fill: "#001E4A"
        }));

        $.each(Stars.instance().stars, function(i, star) {
            backgroundLayer.add(star);
        });

        stage.add(backgroundLayer);

        // create ship
        var shipLayer = new Kinetic.Layer();
        shipLayer.add(Ship.instance().shape);
        stage.add(shipLayer);

        // bullets
        var bulletLayer = new Kinetic.Layer();
        stage.add(bulletLayer);

        stage.onFrame(function(frame) {
            Stars.instance().update();
            Ship.instance().update();
        });

        function start() {
            console.log ("stage starting");
            stage.start();
        }

        return {
            backgroundLayer: backgroundLayer,
            shipLayer: shipLayer,
            bulletLayer: bulletLayer,
            start: start
        };
    }

    return {
        instance: function() {
            if (!instantiated) {
                instantiated = init();
            }
            return instantiated;
        }
    };
})();

var Ship = (function() {
    var instantiated;

    function init() {
        var shape = new Kinetic.Shape({
            x: window.innerWidth / 2,
            y: window.innerHeight / 2,
            centerOffset: {
                x: 8,
                y: 12
            },
            drawFunc: function() {
                var context = this.getContext();
                context.beginPath();
                context.moveTo(8, 0);
                context.lineTo(16, 21);
                context.quadraticCurveTo(8, 10, 0, 21);
                context.closePath();
                this.fillStroke();
            },

            fill: "#E3E186",
            stroke: "green",
            strokeWidth: 1
        });

        var velocity = {
            x: 0,
            y: -1
        };

        var acceleration = 0;
        var rotation = 0;

        var bullets = [];

        function getVelocity() {
            // copy for safety
            return {
                x: velocity.x,
                y: velocity.y
            };
        }

        function setAcceleration(accel) {
            acceleration += accel;
        }

        function rotateAngleInDeg(angle) {
            rotation += angle;
        }

        function update() {
            // update angle
            if (rotation != 0) {
                shape.rotateDeg(rotation);
                rotation = 0;
            }

            // update velocity if accelerating
            if (acceleration != 0) {
                // determine angle of movement
                var movementAngle = shape.getRotation() + Math.PI * 3 / 2;

                // update velocity
                velocity.x += Math.cos(movementAngle) * acceleration;
                velocity.y += Math.sin(movementAngle) * acceleration;
                acceleration = 0;
            }

            // limit velocity
            var speed = hypotenuse(velocity.x, velocity.y);
            if (speed > MAX_SPEED) {
                speed = MAX_SPEED;
            } else if (speed > 0.1) {
                speed -= DRAG;
            }
            var speedAngle = Math.atan2(velocity.y, velocity.x);
            velocity.x = Math.cos(speedAngle) * speed;
            velocity.y = Math.sin(speedAngle) * speed;

            // update position
            shape.x += velocity.x;
            shape.y += velocity.y;

            // adjust screen
            adjustScreenPosition(shape, SCREEN_WIDTH, SCREEN_HEIGHT);

            Asteroids.instance().shipLayer.draw();

            // update bullets
            var remainingBullets = [];
            $.each(bullets, function(i, bullet) {
                bullet.update();
                if (bullet.destroy) {
                    Asteroids.instance().bulletLayer.remove(bullet.shape);
                } else {
                    remainingBullets.push(bullet);
                }
            });

            bullets = remainingBullets;

            Asteroids.instance().bulletLayer.draw();
        }

        function shoot() {
            var bullet = new Bullet();
            bullet.shape.x = shape.x + shape.getCenterOffset().x - bullet.shape.getCenterOffset().x;
            bullet.shape.y = shape.y + shape.getCenterOffset().y - bullet.shape.getCenterOffset().y;
            bullet.setAngle(shape.getRotation() + Math.PI * 3 / 2);
            bullets.push(bullet);

            Asteroids.instance().bulletLayer.add(bullet.shape);
        }

        return {
            shape: shape,
            update: update,
            getVelocity: getVelocity,
            accelerate: setAcceleration,
            turn: rotateAngleInDeg,
            shoot: shoot
        };
    }

    return {
        instance: function() {
            if (!instantiated) {
                instantiated = init();
            }
            return instantiated;
        }
    };
})();

var Stars = (function() {
    var instantiated;

    function init() {
        var stars = [];

        // background stars
        createStars(400, stars, 5, 3, 1, "white", 0.5, 0.1);

        // foreground stars
        createStars(100, stars, 6, 4, 2, "white", 0.8, 1 / 6);

        function createStars(count, array, points, outerRadius, innerRadius, color, alpha, velocityRatio) {
            for (var i = 0; i < count; i++) {
                array.push(new Kinetic.Star({
                    points: points,
                    outerRadius: outerRadius,
                    innerRadius: innerRadius,
                    x: Math.random() * SCREEN_WIDTH * BACKGROUND_SIZE_MULT,
                    y: Math.random() * SCREEN_HEIGHT * BACKGROUND_SIZE_MULT,
                    rotation: Math.random() * Math.PI * 2,
                    fill: color,
                    alpha: alpha,

                    // custom
                    ratio: velocityRatio
                }));
            }
        }

        function updateStarPositions() {
            var shipVel = Ship.instance().getVelocity();

            for (var i = 0; i < stars.length; i++) {
                var star = stars[i];

                star.x -= shipVel.x * star.ratio;
                star.y -= shipVel.y * star.ratio;

                adjustScreenPosition(star, SCREEN_WIDTH * BACKGROUND_SIZE_MULT, SCREEN_HEIGHT * BACKGROUND_SIZE_MULT);
            }

            Asteroids.instance().backgroundLayer.draw();
        }

        return {
            stars: stars,
            update: updateStarPositions
        };
    }

    return {
        instance: function() {
            if (!instantiated) {
                instantiated = init();
            }
            return instantiated;
        }
    };
})();

/* Classes */

function Bullet() {

    var velocity = 10;
    var angle;
    var that = this;

    this.destroy = false;

    this.shape = new Kinetic.Shape({
        centerOffset: {
            x: 4,
            y: 4
        },
        drawFunc: function() {
            var c = this.getContext();

            var gradient = c.createRadialGradient(4, 4, 0.1, 4, 4, 5);
            gradient.addColorStop(0.1, "rgba(255, 255, 255, 1)");
            gradient.addColorStop(0.4, "rgba(255, 0, 0, 0.6)");
            gradient.addColorStop(1, "rgba(255, 255, 0, 0.1)");

            this.setFill(gradient);

            c.beginPath();
            c.arc(4, 4, 5, 0, Math.PI * 2, true);
            c.closePath();
            this.fillStroke();
        }
    });

    this.setAngle = function(a) {
        angle = a;
    }

    this.update = function() {
        that.shape.x += Math.cos(angle) * velocity;
        that.shape.y += Math.sin(angle) * velocity;

        // mark for destruction if need
        if (that.shape.x < 0 || that.shape.x > SCREEN_WIDTH || that.shape.y < 0 || that.shape.y > SCREEN_HEIGHT) {
            that.destroy = true;
        }
    }
}

/* Utilities */

function hypotenuse(x, y) {
    return Math.sqrt(x * x + y * y);
}

function adjustScreenPosition(shape, width, height) {
    if (shape.x >= width) {
        shape.x -= width;
    } else if (shape.x < 0) {
        shape.x += width;
    }

    if (shape.y >= height) {
        shape.y -= height;
    } else if (shape.y < 0) {
        shape.y += height;
    }
}