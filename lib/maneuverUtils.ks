RUNONCEPATH("0:/lib/ship.ks").

GLOBAL FUNCTION burnTime {
    RETURN burnTimeBefore() + burnTimeAfter().
}

GLOBAL FUNCTION burnTimeBefore {
    PARAMETER maneuver IS nextNode.

    SET curIsp TO currentISP().
    SET halfDv TO maneuver:deltav:mag / 2.
    SET massAfterFirstHalfBurn TO ship:mass / constant:E ^ (halfDv/curISP/constant:g0).
    SET bTime to (ship:mass - massAfterFirstHalfBurn) / (ship:availableThrust / curISP / constant:g0).

    RETURN bTime.
}

GLOBAL FUNCTION burnTimeAfter {
    PARAMETER maneuver IS nextNode.

    SET curIsp TO currentISP().
    SET halfDv TO maneuver:deltav:mag / 2.
    SET massAfterFirstHalfBurn TO ship:mass / constant:E ^ (halfDv/curISP/constant:g0).
    SET massAfterSecondHalfBurn TO massAfterFirstHalfBurn / constant:E ^ (halfDv/curISP/constant:g0).
    SET bTime to (massAfterFirstHalfBurn - massAfterSecondHalfBurn) / (ship:availableThrust / curISP / constant:g0).

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
    SET bTimeBefore TO burnTimeBefore(maneuverNode).
    SET bTimeAfter TO burnTimeAfter(maneuverNode).
    PRINT "Preparing for maneuver".
    LOCK steering TO lookDirUp(maneuverNode:burnvector, SHIP:facing:topvector).

    WAIT UNTIL TIME:SECONDS > (maneuverNode:time - bTimeBefore).
    SET startBurn TO TIME:SECONDS.
    LOCK throttle TO 1.
    WAIT UNTIL TIME:SECONDS > (startBurn + bTimeBefore + bTimeAfter).
    LOCK throttle TO 0.

    SAS on.
}

GLOBAL FUNCTION circat {
    PARAMETER at IS "apo".

    SET targetAlt TO ship:orbit:apoapsis.
    SET targetEta TO eta:apoapsis.
    if (at = "per") {
        SET targetAlt TO ship:orbit:periapsis.
        SET targetEta TO eta:periapsis.
    }

    SET rAtTarget TO targetAlt + ship:orbit:body:radius.
    SET a TO ship:orbit:semimajoraxis.
    SET vAtTarget TO sqrt(ship:orbit:body:mu * (2/rAtTarget - 1/a)).
    SET targetV TO sqrt(ship:orbit:body:mu / (targetAlt + ship:orbit:body:radius)).
    SET dV TO targetV - vAtTarget.

    SET circNode TO NODE(TIME:seconds + targetEta, 0, 0, dV).
    ADD circNode.
}