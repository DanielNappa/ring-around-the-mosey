# Ring Around the Mosey (AirDrop Enabler for rooted Pixel 9 series devices)

A KernelSU/Magisk module to force-enable Google's staged A/B rollout of "Mosey" (native Android-to-Apple AirDrop interoperability Quick Share Extension). 

**Disclaimer:** This is currently intended for the Pixel 9 series and has only been explicitly tested on a **Pixel 9 Pro** running 16.0.0 (BP4A.260205.002, Feb 2026) with versions 25.34.34 and 26.08.33 of `com.google.android.gms`. 

## Prerequisites
* **Device:** Pixel 9 Series (Tested: Pixel 9 Pro).
* **Root:** Magisk or KernelSU Next.
* **Firmware:** A recent Google Play Services / Quick Share build containing the `com.google.android.mosey` package.


## Tests to run before installing
Confirm your device has the `com.google.android.mosey` package: 
```bash
pm path com.google.android.mosey
```
Open Quick Share normally, or invoke its MainActivity manually with:
```bash
am start -n com.google.android.gms/.nearby.sharing.main.MainActivity
```
**Ensure that visibility is set to "Everyone"**

With Quick Share still open, run the following in a root shell (Termux/ADB):

```bash
su -c 'am start-foreground-service -n com.google.android.mosey/.ExternalSharingService -a com.google.android.nearby.SHARING_PROVIDER'
```

If your Apple devices populate in the visibility list, your device is capable, and this module will work for you. (Note: The devices will disappear upon UI state changes without the module installed).

## Installation
1. Download `mosey-airdrop-enabler-v0.0.1-alpha.zip` from Releases.
2. Flash via Magisk or KernelSU.
3. Reboot.

## Technical Overview
Google Play Services (GMS) actively gates the `ExternalSharingService` based on server-side Phenotype flags, preventing it from starting natively. Furthermore, even if forcefully started, GMS will re-evaluate eligibility and kill the foreground service upon Quick Share UI lifecycle changes (e.g., switching tabs or closing the panel).

**The Module:** `service.sh` utilizes a continuous watchdog loop to catch the GMS teardown and immediately re-invoke the service with the `SHARING_PROVIDER` intent via root, bypassing the permission check.

**Durable State Provisioning:** Limited testing indicates an observed side-effect: if the module is left enabled for an extended period (hours), GMS appears to write a durable local enrollment state, likely due to deferred background capability syncs completing. Once this occurs, the module can be uninstalled, and the feature will persist natively across reboots. This state is only lost if Google Play Services storage is explicitly cleared.

## Known Bugs
* Sending raw `.txt` files currently causes the sender to hang on "Waiting." The Android receiver appears to lack a complete MIME handler for Apple's plain-text payload structure in this build.
