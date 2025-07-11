#!/bin/bash
echo "Content-type: text/html; charset=UTF-8"
echo

# Only handle POST requests
if [ "$REQUEST_METHOD" != "POST" ]; then
  echo "<h3>🚫 This script only handles POST requests.</h3>"
  exit 1
fi

# Read POST body safely
read -n "$CONTENT_LENGTH" POST_DATA

# Extract individual fields
customer_id=$(echo "$POST_DATA" | sed -n 's/.*customer_id=\([^&]*\).*/\1/p')
driver_id=$(echo "$POST_DATA" | sed -n 's/.*driver_id=\([^&]*\).*/\1/p')
pickup=$(echo "$POST_DATA" | sed -n 's/.*pickup=\([^&]*\).*/\1/p')
drop=$(echo "$POST_DATA" | sed -n 's/.*drop=\([^&]*\).*/\1/p')

# Decode '+' and '%20' into spaces
pickup=$(echo "$pickup" | sed 's/+/ /g; s/%20/ /g')
drop=$(echo "$drop" | sed 's/+/ /g; s/%20/ /g')

# Optional: Validate inputs
if [[ -z "$customer_id" || -z "$driver_id" || -z "$pickup" || -z "$drop" ]]; then
  echo "<h3>❗ Missing form data. Please go back and try again.</h3>"
  exit 1
fi

# Lookup distance from Oracle DB
distance=$(sqlplus -s mkumar/Mahi1992@192.168.31.230:1521/xepdb1 <<EOF
SET HEADING OFF FEEDBACK OFF PAGESIZE 0
SELECT KM FROM Distances WHERE Pickup = '$pickup' AND Drop_Loc = '$drop';
EXIT;
EOF
)
distance=$(echo "$distance" | xargs)

# Default to 0 if distance not found
if [ -z "$distance" ]; then
  distance=0
fi

# Fare: ₹15 per km
fare=$(echo "$distance * 15" | bc)

# Insert into Bookings table
sqlplus -s mkumar/Mahi1992@192.168.31.230:1521/xepdb1 <<EOF
INSERT INTO Bookings (
  Customer_ID, Driver_ID,
  Pickup_Location, Drop_Location,
  Distance_KM, Fare,
  Start_Time, Status
)
VALUES (
  '$customer_id', '$driver_id',
  '$pickup', '$drop',
  $distance, $fare,
  SYSTIMESTAMP, 'Pending'
);
COMMIT;
EXIT;
EOF

# ✅ Confirmation Output
echo "<html><body><h2>✅ Booking Successful</h2>"
echo "<p><b>Customer:</b> $customer_id</p>"
echo "<p><b>Route:</b> $pickup → $drop</p>"
echo "<p><b>Distance:</b> $distance km</p>"
echo "<p><b>Fare:</b> ₹$fare</p>"
echo "<a href='/book_ride.html'>➕ Book Again</a> | "
echo "<a href='/cgi-bin/show_pending.cgi'>📋 View Pending</a>"
echo "</body></html>"