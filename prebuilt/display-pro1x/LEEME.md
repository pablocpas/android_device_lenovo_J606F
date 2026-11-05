Bloque de pantalla del Pro1-X (`proprietary_vendor_fxtec_pro1x`), para usar con `libsdmcore` compilado de CAF.

El `libsdmextension.so` de Lenovo S320383 no encaja con ese código: `composer` se caía en
`MapBufferToFbId`. Probado en la tablet con el kernel stock el 2026-11-05: sin caídas de `composer`, 0 de
`Composition strategies exhausted`, 0 de `r1 only virt plane`, e imagen correcta.

`build_j606f.sh` los copia sobre `vendor/lenovo/J606F/proprietary/vendor/lib64/` antes de compilar.
