#!/bin/bash
sqlplus -s mkumar/Mahi1992@192.168.31.230:1521/xepdb1 <<EOF
SET HEADING OFF FEEDBACK OFF PAGESIZE 0
SELECT '<option value="' || Name || '">' || Name || '</option>' FROM Locations;
EXIT;
EOF