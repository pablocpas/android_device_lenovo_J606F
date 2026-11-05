# SPDX-License-Identifier: Apache-2.0
# Experimental: comparar con la configuracion base despues del primer arranque.
# Fuente: yaap/device_oneplus_sm8650-common, system.prop, revision
# 3995f9d9bc4c607ed77ca8199e0f38581adab303 (2026-11-03).
# La implementacion de ambas propiedades ya existe en LineageOS 23.2 lmkd.
# ratio=2 es una hipotesis que se debe contrastar con las estadisticas de zram;
# en una tablet de 4 GB, retrasar cierres tambien puede aumentar los bloqueos.
# Activar solo para una compilacion comparativa: J606F_YAAP_MEMORY=true.

ifeq ($(J606F_YAAP_MEMORY),true)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.lmk.swap_compression_ratio=2 \
    ro.lmk.relaxed_available_memory=true
endif
