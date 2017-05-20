#/bin/bash


echo
echo ================================================================================
echo Sleeping until CPU Credits Regen
echo ================================================================================

while ! ./check_cpu_credits.sh; do
	# Sleep 1h
	sleep 3600
done
