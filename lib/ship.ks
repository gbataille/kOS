GLOBAL FUNCTION maxTwr {
    return ship:availablethrust / ship:mass / constant:g0.
}

GLOBAL FUNCTION lockTwr {
    PARAMETER twr.
    lock throttle to (twr * ship:mass * constant:g0 / ship:availablethrust).
}