local mathx = {}

function mathx.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

function mathx.near(a, b, eps)
    return math.abs(a - b) < (eps or 0.001)
end

return mathx
