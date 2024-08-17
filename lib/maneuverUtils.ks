RUNONCEPATH("0:/lib/ship.ks").

GLOBAL FUNCTION burnTime {
    SET maneuver TO nextNode.
    SET curIsp TO currentISP().
    SET massAfterBurn TO ship:mass / constant:E ^ (nextNode:deltav:mag/curISP/constant:g0).
    SET bTime to (ship:mass - massAfterBurn) / (ship:availableThrust / curISP / constant:g0).
    RETURN bTime.
}

GLOBAL FUNCTION xman {
    if (NOT hasNode) {
        PRINT "No maneuver planned".
        RETURN.
    }
    
    if (currentIsp() < 0) {
        PRINT "No active engine".
        RETURN.
    }

    SAS off.
    SET maneuverNode TO nextNode.

    clearScreen.
    SET bTime TO burnTime().
    PRINT "Burn time is     : " + bTime.
    LOCK steering TO lookDirUp(maneuverNode:burnvector, SHIP:facing:topvector).

    WAIT UNTIL TIME:SECONDS > maneuverNode:time - (bTime / 2).
    SET startBurn TO TIME:SECONDS.
    LOCK throttle TO 1.
    WAIT UNTIL TIME:SECONDS > startBurn + bTime.
    LOCK throttle TO 0.

    SAS on.
}