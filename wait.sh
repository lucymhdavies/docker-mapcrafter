#/bin/bash


echo
echo ================================================================================
echo Sleeping until CPU Credits Regen
echo ================================================================================

while ! ./check_cpu_credits.sh >/dev/null; do
	date
	./check_cpu_credits.sh
	echo

	# Sleep 1h
	sleep 3600
done

echo "Back up beyond WARNING level of credits"
