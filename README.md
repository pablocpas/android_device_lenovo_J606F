# LineageOS 23.2 device tree for the Lenovo Tab P11 (TB-J606F)

Unofficial, work in progress. Snapshot of a working base before the optimization phase.

| | |
|---|---|
| Device | Lenovo Tab P11 TB-J606F (Wi-Fi), codename J606F |
| SoC | Qualcomm SM6115 (`bengal`), Adreno 610 |
| Android | 16 (LineageOS 23.2) on the Android 11 vendor (Lenovo S320383) |
| Base | Fxtec Pro1-X tree (same SoC), adapted to the Lenovo hardware |

## Repositories

- `device/lenovo/J606F`: this repository, with `patches/` for AOSP/LineageOS projects
- `vendor/lenovo/J606F`: [proprietary_vendor_lenovo_J606F](https://github.com/pablocpas/proprietary_vendor_lenovo_J606F)
- `kernel/lenovo/sm6115`: [android_kernel_lenovo_sm6115](https://github.com/pablocpas/android_kernel_lenovo_sm6115),
  branch `j606f-4.19.325` (LineageOS `kernel_fxtec_sm6115` 4.19.325 + the Lenovo drivers)

`manifests/j606f.xml` is a local manifest for all three.

## Build

```sh
repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs
mkdir -p .repo/local_manifests && cp <this repo>/manifests/j606f.xml .repo/local_manifests/
repo sync
bash device/lenovo/J606F/patches/aplicar.sh
source build/envsetup.sh && breakfast J606F userdebug && m bacon
```

Build switches (environment variables):

| Variable | Default | Effect |
|---|---|---|
| `J606F_KERNEL` | `stock` | `stock`: Lenovo 4.19.157 prebuilt (`prebuilt/kernel`). `4.19.325`: the new kernel, from `prebuilt/kernel-4.19.325/` (Image.gz, dtb, modules), which you have to build from the kernel repo |
| `J606F_WIDEVINE_L3` | `false` | `true` forces Widevine L3 |
| `J606F_SELINUX_PERMISSIVE` | `false` | Permissive SELinux, only for debugging |

## Patches

`patches/<project path>/` holds what Android 16 needs on this old vendor and kernel:
`epoll_pwait2` and `close_range` fallbacks (bionic), BPF on 4.19 (Connectivity), sdcardfs
fallback (vold), non-fatal cgroup errors, Qualcomm perf HAL hints, and
`frameworks/av`: **SecureBuffer keeps its range**. Since `MediaCodecBuffer::setRange()`
uses `ABuffer::setRangeWithStatus()`, the range of secure buffers (no CPU-visible data)
is silently dropped, and the OMX secure decoder gets the whole buffer: green, corrupted
video or Venus crashes with Widevine L1. Devices on Codec2 do not use this path.

## Status

Works with the stock kernel: display, touch and pen, Wi-Fi, Bluetooth, audio (4 speakers),
both cameras, charging, sensors, Widevine L1 (with the patch above).

Kernel 4.19.325: tested only booted from RAM (`fastboot boot`). Display, touch, Wi-Fi,
USB-C, audio and both cameras work; the ported Lenovo charging logic (cycle-based voltage
maintenance, warm limit, charging pause) is not validated yet.

Known issues: recovery rotated 180 degrees, volume keys swapped in recovery, dock
keyboard charging modes not ported.

## Not to do on this device

Never run `fastboot flashing lock` with this ROM. Do not touch `persist`, `modemst1`,
`modemst2`, `fsg` or `fsc`.
