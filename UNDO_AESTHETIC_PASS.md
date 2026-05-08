# Undo aesthetic pass

Created before changing CAD:
- Backup branch: backup/pre-aesthetic-20260508-194037
- Previous preview-latest target: preview-v2-35-modular-base-20260507-082546
- Aesthetic preview target: preview-v2-36-aesthetic-pass-20260508-200048

To undo local CAD edits and restore the previous preview pointer:

```bash
git reset --hard ef0b8f84b5985a6ae9eca44105e914f73c120e5e
git restore dual_pi5_macmini_v2_1_corrected_stack_koya.scad
ln -sfn preview-v2-35-modular-base-20260507-082546 preview-latest
```

If a commit gets made for the aesthetic pass, reset/revert to the backup branch instead:

```bash
git reset --hard backup/pre-aesthetic-20260508-194037
ln -sfn preview-v2-35-modular-base-20260507-082546 preview-latest
```

## Undo dual NF-F12 top update

Created before changing for the two Noctua NF-F12 fans:
- Backup branch: backup/pre-nf-f12-dual-top-20260508-201414
- Previous preview-latest target before NF-F12 update: preview-v2-36-aesthetic-pass-20260508-200048
- NF-F12 preview target: preview-v2-37-dual-nf-f12-top-20260508-203432

To undo only the NF-F12 edit before it is pushed, reset/revert this latest commit once created, or restore from the backup branch above and reset preview-latest:

```bash
git reset --hard backup/pre-nf-f12-dual-top-20260508-201414
ln -sfn preview-v2-36-aesthetic-pass-20260508-200048 preview-latest
```
