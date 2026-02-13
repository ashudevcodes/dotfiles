local physics = {}

-------------------------------------------------
-- Spring Motion
-------------------------------------------------
function physics.spring(value, velocity, target, stiffness, damping)
    local force = (target - value) * stiffness
    velocity = (velocity + force) * damping
    value = value + velocity
    return value, velocity
end

-------------------------------------------------
-- Smooth Interpolation
-------------------------------------------------
function physics.smooth(current, target, speed)
    return current + (target - current) * speed
end

-------------------------------------------------
-- Decay
-------------------------------------------------
function physics.decay(value, factor)
    return value * factor
end

-------------------------------------------------
-- Motor Rotation Physics
-------------------------------------------------
function physics.motor(speed, target, inertia, damping, torque, dt)
    local t = (target - speed) * torque
    local accel = (t - damping * speed) / inertia
    return speed + accel * dt
end

return physics
