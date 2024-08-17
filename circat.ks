RUNONCEPATH("0:/lib/ship.ks").

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

SET massAfterBurn TO ship:mass / constant:E ^ (circNode:deltav:mag/currentISP()/constant:g0).
SET burnTime to circNode:deltav:mag * (ship:mass - massAfterBurn) / ship:AVAILABLETHRUST / LN(ship:MASS/massAfterBurn).
SET burnTime2 to (ship:mass - massAfterBurn) / (ship:availableThrust / currentISP() / constant:g0).

PRINT "-----------".
PRINT "Ship mass:       " + ship:mass.
PRINT "Ship wetmass:    " + ship:wetmass.
PRINT "Ship drymass:    " + ship:drymass.
PRINT "Isp:             " + currentIsp().
PRINT "∂v maneuver:     " + circNode:deltav:mag.
PRINT "burn time:       " + burnTime.
PRINT "burn time2:      " + burnTime2.
PRINT "mass after burn: " + massAfterBurn.
PRINT "fuel mass:       " + (ship:mass - massAfterBurn).
PRINT "-----------".