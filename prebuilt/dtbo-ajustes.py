#!/usr/bin/env python3
"""Genera dtbo-4.19.325.img a partir del dtbo.img de stock (S320383).

Cambia en el sitio, sin recompilar nada, propiedades de 4 bytes de los nodos de
panel. El resto del fichero queda identico byte a byte.

  - nt36523w_boe_2k_video (el panel de la J606F): qcom,mdss-dsi-bl-min-level 1 -> 33.
    Con el mapeo de brillo del kernel 4.19.325 (8d930ff366), el nivel 1 era 1/4095
    del backlight: negro. 33/4095 es el minimo usable medido en la tablet.

Uso: dtbo-ajustes.py dtbo.img dtbo-4.19.325.img
"""
import struct
import sys

CAMBIOS = {
    ("qcom,mdss_dsi_nt36523w_boe_2k_video", "qcom,mdss-dsi-bl-min-level"): (1, 33),
}


def parchear_fdt(blob, base, salida):
    magic, total, off_struct, off_strings = struct.unpack_from(">IIII", blob, base)
    assert magic == 0xD00DFEED, "entrada sin cabecera FDT"
    def cadena(o):
        fin = blob.index(b"\0", base + off_strings + o)
        return blob[base + off_strings + o:fin].decode()
    # La alineacion de 4 bytes del FDT es relativa al inicio de cada entrada.
    p = base + off_struct
    pila, hechos = [], 0
    while True:
        tok = struct.unpack_from(">I", blob, p)[0]
        p += 4
        if tok == 1:  # BEGIN_NODE
            fin = blob.index(b"\0", p)
            pila.append(blob[p:fin].decode())
            p = base + ((fin + 1 - base + 3) & ~3)
        elif tok == 2:  # END_NODE
            pila.pop()
        elif tok == 3:  # PROP
            ln, nameoff = struct.unpack_from(">II", blob, p)
            p += 8
            clave = (pila[-1] if pila else "", cadena(nameoff))
            if clave in CAMBIOS and ln == 4:
                antes, despues = CAMBIOS[clave]
                actual = struct.unpack_from(">I", blob, p)[0]
                assert actual == antes, f"{clave}: esperaba {antes}, hay {actual}"
                struct.pack_into(">I", salida, p, despues)
                hechos += 1
            p = base + ((p + ln - base + 3) & ~3)
        elif tok == 4:  # NOP
            pass
        elif tok == 9:  # END
            return hechos
        else:
            raise ValueError(f"token FDT desconocido {tok}")


def main(entrada, destino):
    blob = open(entrada, "rb").read()
    salida = bytearray(blob)
    magic, total, hsize, esize, count, eoff = struct.unpack_from(">IIIIII", blob, 0)
    assert magic == 0xD7B7AB1E, "no es un dtbo.img"
    total_hechos = 0
    for i in range(count):
        size, off = struct.unpack_from(">II", blob, eoff + i * esize)
        n = parchear_fdt(blob, off, salida)
        if n:
            print(f"entrada {i}: {n} cambio(s)")
        total_hechos += n
    assert total_hechos > 0, "no se ha cambiado nada"
    open(destino, "wb").write(salida)
    print(f"{total_hechos} cambios en {destino}")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
