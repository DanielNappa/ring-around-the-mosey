#!/system/bin/sh

until [ "$(getprop sys.boot_completed)" = "1" ]; do
  sleep 5
done

# Give GMS an extra 20 seconds to load its internal Phenotype flags
sleep 20


while true; do
  # Check if the ExternalSharingService is currently in the active services list
  if ! dumpsys activity services com.google.android.mosey | grep -q "ExternalSharingService"; then
    # Force-start if inactive or previously killed
    am start-foreground-service -n com.google.android.mosey/.ExternalSharingService -a com.google.android.nearby.SHARING_PROVIDER
  fi
  sleep 10
done
