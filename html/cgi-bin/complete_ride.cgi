#!/bin/bash
echo "Content-type: text/html; charset=UTF-8"
echo

# Ensure method is POST
if [ "$REQUEST_METHOD" != "POST" ]; then
  echo "<h3>🚫 Invalid request method</h3>"
  exit 1
fi

# Read Booking ID
read -n "$CONTENT_LENGTH" POST_DATA
id=$(echo "$POST_DATA" | sed -n 's/.*id=\([^&]*\).*/\1/p')

if [ -z "$id" ]; then
  echo "<h3>❗ Missing Booking ID</h3>"
  exit 1
fi

# Update booking status
sqlplus -s mkumar/Mahi1992@192.168.31.230:1521/xepdb1 <<EOF
UPDATE Bookings
SET Status = 'Completed',
    End_Time = SYSTIMESTAMP
WHERE Booking_ID = $id;
COMMIT;
EXIT;
EOF

# Confirmation page
echo "<html><body style='font-family:sans-serif;'>"
echo "<h2>✅ Ride Marked as Completed</h2>"
echo "<p>Booking ID <strong>$id</strong> was successfully updated in the database.</p>"
echo "<a href='/cgi-bin/show_pending.cgi'>📋 View Pending Rides</a><br><br>"
echo "<a href='/book_ride.html'>➕ Book New Ride</a>"
echo "</body></html>"