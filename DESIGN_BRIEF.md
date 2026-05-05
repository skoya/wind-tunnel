# DESIGN_BRIEF.md

## Goal

Create a desk-friendly, serviceable, modular cooling stand for:
- 2× Raspberry Pi 5 units with Waveshare PoE M.2 HAT+ B
- 1× UGREEN Thunderbolt/USB-C NVMe enclosure
- 1× Apple Mac mini M4

## Layout

```text
SIDE VIEW

        Mac mini M4
   ┌─────────────────┐
   │  top guide rails │
   ├──── top fan ─────┤  upward airflow
   │ removable lid    │
┌──┴─────────────────┴──┐
│   Pi cassette  Pi cassette │
│                         │
│      UGREEN raised bay   │
│                         │
│ front 140mm fan  → rear exhaust/cables
└─────────────────────────┘
```

## Critical corrections from earlier versions

- UGREEN must be below the Pis.
- Pis must sit above the UGREEN bay.
- KOYA grille must be clipped inside the front cassette.
- Mac mini support must not block central underside airflow.
- The whole design must be modular, not one solid object.
