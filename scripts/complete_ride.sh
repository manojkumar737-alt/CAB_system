#!/bin/bash
# complete_ride.sh

booking_id=101
distance=12.5  # in km
FARE_PER_KM=15
fare=$(echo "$distance * $FARE_PER_KM" | bc)

sqlplus -s mkumar/password@192.168.31.230:1521/xepdb1 <<EOF
UPDATE Bookings
SET
  End_Time = SYSTIMESTAMP,
  Distance_KM = $distance,
  Fare = $fare,
  Status = 'Completed'
WHERE
  Booking_ID = $booking_id;

COMMIT;
EXIT;
EOF