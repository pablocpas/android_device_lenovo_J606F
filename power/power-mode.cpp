/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 *
 * Doble toque para despertar (DOUBLE_TAP_TO_WAKE) en la Lenovo TB-J606F.
 * Basado en device/samsung/gta4l-common/power. El driver Himax HX83102P de
 * Lenovo (drivers/lenovo/input/touchscreen/himax83102p) acepta "1"/"0" en
 * /proc/android_touch/gesture_control (HIMAX_PROC_SMWP_FILE).
 */

#include <android-base/file.h>
#include <unistd.h>

#include <aidl/android/hardware/power/Mode.h>

using ::aidl::android::hardware::power::Mode;

// Espacio de nombres de libperfmgr (hardware/lineage/interfaces/power-libperfmgr)
namespace aidl {
namespace google {
namespace hardware {
namespace power {
namespace impl {
namespace pixel {

// Nodos conocidos; la variante con panel Novatek NT36523W queda por confirmar.
static constexpr const char* kTapToWakeNodes[] = {
        "/proc/android_touch/gesture_control",
};

static const char* findTapToWakeNode() {
    for (const char* node : kTapToWakeNodes) {
        if (access(node, W_OK) == 0) return node;
    }
    return nullptr;
}

bool isDeviceSpecificModeSupported(Mode type, bool* _aidl_return) {
    switch (type) {
        case Mode::DOUBLE_TAP_TO_WAKE:
            *_aidl_return = findTapToWakeNode() != nullptr;
            return true;
        default:
            return false;
    }
}

bool setDeviceSpecificMode(Mode type, bool enabled) {
    switch (type) {
        case Mode::DOUBLE_TAP_TO_WAKE: {
            const char* node = findTapToWakeNode();
            if (node != nullptr) {
                ::android::base::WriteStringToFile(enabled ? "1" : "0", node);
            }
            return true;
        }
        default:
            return false;
    }
}

}  // namespace pixel
}  // namespace impl
}  // namespace power
}  // namespace hardware
}  // namespace google
}  // namespace aidl
