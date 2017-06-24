#!/bin/bash
# From https://gist.github.com/daniilyar-confyrm/335d2980e65b7fee7cdd004ec535fb5e

set -e

OK=0
WARN=1
CRIT=2
UNKNOWN=3

function get_warning_limit {
	case "$1" in
	"t2.nano")
		echo "15"
		;;
	"t2.micro")
		echo "25"
		;;
	"t2.small")
		echo "35"
		;;
	"t2.medium")
		echo "40"
		;;
	"t2.large")
		echo "40"
		;;
	esac;
}

function get_critical_limit {
	case "$1" in
	"t2.nano")
		echo "5"
		;;
	"t2.micro")
		echo "10"
		;;
	"t2.small")
		echo "15"
		;;
	"t2.medium")
		echo "20"
		;;
	"t2.large")
		echo "25"
		;;
	esac;
}

function get_max_cpu_credits {
	case "$1" in
	"t2.nano")
		echo "72"
		;;
	"t2.micro")
		echo "144"
		;;
	"t2.small")
		echo "288"
		;;
	"t2.medium")
		echo "576"
		;;
	"t2.large")
		echo "864"
		;;
	esac;
}

INSTANCE_TYPE=`curl -sL http://169.254.169.254/latest/meta-data/instance-type`

if [[ $INSTANCE_TYPE =~ t2.* ]]; then
  REGION=`curl -sL http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
  INSTANCE_ID=`curl -sL http://169.254.169.254/latest/meta-data/instance-id`

  START_TIME=`date -u -d "10 minutes ago" +%Y-%m-%dT%H:%M:%S`  
  END_TIME=`date -u +%Y-%m-%dT%H:%M:%S`
  
  WARNING_LIMIT=`get_warning_limit ${INSTANCE_TYPE}`
  CRITICAL_LIMIT=`get_critical_limit ${INSTANCE_TYPE}`

  CPU_CREDITS_METADATA=`aws cloudwatch get-metric-statistics --namespace AWS/EC2 --region ${REGION} --metric-name CPUCreditBalance --start-time "${START_TIME}" --end-time "${END_TIME}" --period 60 --statistics Average --dimensions Name=InstanceId,Value="${INSTANCE_ID}" | jq '.Datapoints[] | .["Average", "Timestamp"]' | tail -n 2`

  CPU_CREDITS=`echo -e "${CPU_CREDITS_METADATA}" | head -n 1`
  TIMESTAMP=`echo -e "${CPU_CREDITS_METADATA}" | tail -n 1 | tr -d '"'`
  
  if (( $(echo "$CPU_CREDITS <= $CRITICAL_LIMIT" | bc -l) )); then
    MSG="CRITICAL ($INSTANCE_TYPE) - ${CPU_CREDITS} CPU credits are left"
    STATE=$CRIT
  else
    if (( $(echo "$CPU_CREDITS <= $WARNING_LIMIT" | bc -l) )); then
	  MSG="WARNING ($INSTANCE_TYPE) - ${CPU_CREDITS} CPU credits are left"
	  STATE=$WARN
    else
      MSG="OK ($INSTANCE_TYPE) - ${CPU_CREDITS} CPU credits are left"
	  STATE=$OK
    fi
  fi
else
  MSG="OK ($INSTANCE_TYPE) - I don't need CPU credits"
  STATE=$OK
fi

if [ -z "$TIMESTAMP" ]; then
  TIMESTAMP_STRING="$(date +%s)"
else
  TIMESTAMP_EPOCH=$(date -d $TIMESTAMP +%s)
  TIMESTAMP_STRING="timestamp=${TIMESTAMP_EPOCH}"
fi

if [ -z "$CPU_CREDITS" ]; then
  CPU_CREDITS_STRING=""
else
  CPU_CREDITS_STRING="cpu_credits=${CPU_CREDITS}"
fi

MAX_CPU_CREDITS=`get_max_cpu_credits "$INSTANCE_TYPE"`
echo "$MSG|${TIMESTAMP_STRING} ${CPU_CREDITS_STRING};$WARNING_LIMIT;$CRITICAL_LIMIT;;$MAX_CPU_CREDITS";
exit $STATE
