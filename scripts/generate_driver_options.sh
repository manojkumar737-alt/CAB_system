#!/bin/bash
sqlplus -s mkumar/Mahi1992@192.168.31.230:1521/xepdb1 <<EOF
SET HEADING OFF FEEDBACK OFF PAGESIZE 0
SELECT '<option value="' || Driver_ID || '">' || Name || ' (' || Vehicle_Number || ')</option>' FROM Drivers;
EXIT;
EOF