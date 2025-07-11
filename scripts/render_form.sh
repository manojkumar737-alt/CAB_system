#!/bin/bash
cd "$(dirname "$0")"

driver_opts=$(./generate_driver_options.sh)
location_opts=$(./generate_location_options.sh)
customer_opts=$(./generate_customer_options.sh)

template=../html/book_ride_template.html
output=../html/book_ride.html
tmp_file=$(mktemp)

# Inject DRIVER_OPTIONS
sed "/{{DRIVER_OPTIONS}}/{
  r /dev/stdin
  d
}" "$template" <<< "$driver_opts" > "$tmp_file"

# Inject LOCATION_OPTIONS twice
awk -v opts="$location_opts" '
{
  while (match($0, /{{LOCATION_OPTIONS}}/)) {
    before = substr($0, 1, RSTART - 1)
    after = substr($0, RSTART + RLENGTH)
    $0 = before opts after
  }
  print
}' "$tmp_file" > "${tmp_file}.2"

# Inject CUSTOMER_OPTIONS
awk -v opts="$customer_opts" '
{
  while (match($0, /{{CUSTOMER_OPTIONS}}/)) {
    before = substr($0, 1, RSTART - 1)
    after = substr($0, RSTART + RLENGTH)
    $0 = before opts after
  }
  print
}' "${tmp_file}.2" > "$output"

rm "$tmp_file" "${tmp_file}.2"
echo "[✔] Final form written to $output"