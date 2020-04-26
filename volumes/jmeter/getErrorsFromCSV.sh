cat  errorLog.csv.hr.csv | awk -F, '{ if ($8 ~ /false/)  print $0; }'| column -ts, |less -S

