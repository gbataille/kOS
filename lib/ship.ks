GLOBAL FUNCTION maxTwr {
    return ship:availablethrust / ship:mass / constant:g0.
}

GLOBAL FUNCTION lockTwr {
    PARAMETER twr.
    // max(x, 1) protects against division by 0
    lock throttle to (twr * ship:mass * constant:g0 / max(ship:availablethrust, 1)).
}