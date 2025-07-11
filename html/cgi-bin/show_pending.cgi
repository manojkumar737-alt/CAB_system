#!/bin/bash
echo "Content-type: text/html; charset=UTF-8"
echo

echo "<html><body><h2>Pending Rides</h2><table border='1'>"
echo "<tr><th>ID</th><th>Customer</th><th>Pickup → Drop</th><th>Driver</th><th>Action</th></tr>"

sqlplus -s mkumar/Mahi1992@192.168.31.230:1521/xepdb1 <<EOF | while IFS=',' read id cust pick drop driver
SET HEADING OFF FEEDBACK OFF PAGESIZE 0
SELECT Booking_ID || ',' || Customer_ID || ',' || Pickup_Location || ',' || Drop_Location || ',' || Driver_ID
FROM Bookings WHERE Status = 'Pending' ORDER BY Booking_ID;
EXIT;
EOF
do
  echo "<tr><td>$id</td><td>$cust</td><td>$pick → $drop</td><td>$driver</td><td>"
  echo "<form style='display:inline;' method='post' action='/cgi-bin/complete_ride.cgi'>"
  echo "<input type='hidden' name='id' value='$id'>"
  echo "<input type='submit' value='✅ Complete'>"
  echo "</form>"
  echo "<form style='display:inline;' method='post' action='/cgi-bin/cancel_ride.cgi'>"
  echo "<input type='hidden' name='id' value='$id'>"
  echo "<input type='submit' value='❌ Cancel'>"
  echo "</form></td></tr>"
done

echo "</table><br><a href='/book_ride.html'>➕ Book New Ride</a></body></html>"