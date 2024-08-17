GLOBAL FUNCTION maxTwr {
    return ship:availablethrust / ship:mass / constant:g0.
}

GLOBAL FUNCTION currentTwr {
    return (ship:availablethrust / ship:mass / constant:g0) * throttle.
}

GLOBAL FUNCTION lockTwr {
    PARAMETER twr.
    // max(x, 1) protects against division by 0
    lock throttle to (twr * ship:mass * constant:g0 / max(ship:availablethrust, 1)).
}

GLOBAL FUNCTION currentISP {
   LIST ENGINES in engineList.
   SET totThrust to 0.
   SET thrustRate to 0.
   FOR eng in engineList {
      IF eng:IGNITION {
         SET totThrust to totThrust + eng:AVAILABLETHRUST.
         SET thrustRate to thrustRate + eng:AVAILABLETHRUST/eng:ISP.
      }
   }
   IF (thrustRate > 0) {
      RETURN totThrust / thrustRate.
   } ELSE {
      RETURN -1.
   }
}