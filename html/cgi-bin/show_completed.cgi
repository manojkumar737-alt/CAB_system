#!/bin/bash
echo "Content-type: text/html; charset=UTF-8"
echo

echo "<html><body><h2>Completed Rides</h2><table border='1'>"
echo "<tr><th>ID</th><th>Customer</th><th>Driver</th><th>Pickup</th><th>Drop</th><th>Fare</th></tr>"

sqlplus -s mkumar/Mahi1992@192.168.31.230:1521/xepdb1 <<EOF | while read row
SET HEADING OFF
SET FEEDBACK OFF
SET PAGESIZE 0

SELECT Booking_ID || ',' || Customer_ID || ',' || Driver_ID || ',' || Pickup_Location || ',' || Drop_Location || ',' || Fare
FROM Bookings
WHERE Status = 'Completed'
ORDER BY End_Time DESC;

EXIT;
EOF
do
  IFS=',' read -r id cust driver pick drop fare <<< "$row"
  echo "<tr><td>$id</td><td>$cust</td><td>$driver</td><td>$pick</td><td>$drop</td><td>₹$fare</td></tr>"
done

echo "</table></body></html>"