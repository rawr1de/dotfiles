# Templar - Dell Laptop (Raptor Lake, Intel UHD Graphics)

## Kernel Parameters (GRUB)
i915.enable_psr=0 i915.enable_dc=0 i915.enable_dpst=0

## Known Issues
- Screen adaptive brightness must be disabled in BIOS (Display settings)
- Intel PSR causes screen dimming on content changes (ranger previews, text selection)
- enable_rc6 kernel param is ignored on this kernel version, RC handled by GuC

## Hardware
- GPU: Intel Raptor Lake-P UHD Graphics
- WiFi: Realtek rtw89_8852be
