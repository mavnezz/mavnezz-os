# mavnezz-os — Installation Troubleshooting

Common issues encountered when bringing up a new mavnezz-os host.

## Common Issues and Solutions

### 1. Build Failures

**Error:** `error: getting status of '/nix/store/.../nixos-system-HOSTNAME': No such file or directory`

**Possible Causes:**
- Network connectivity issues
- Flake evaluation errors
- Hardware detection problems

**Solutions:**

1. **Check network connectivity:**
   ```bash
   ping google.com
   curl -I https://cache.nixos.org
   ```

2. **Retry the build manually:**
   ```bash
   cd ~/mavnezz-os
   sudo nixos-rebuild build --flake .#<hostname>
   ```

3. **Verify your host exists in the flake:**
   ```bash
   grep -n "<hostname>" flake.nix
   ls devices/*/<hostname>/
   ```

### 2. Hardware Detection Issues

**Error:** GPU profile not working correctly or display issues after reboot.

**Solution:** Regenerate the hardware configuration for the affected host:

```bash
sudo nixos-generate-config --show-hardware-config > devices/<form>/<hostname>/hardware.nix
```

Then rebuild and switch.

### 3. Permission Errors

**Error:** `permission denied` or `operation not permitted`

**Solution:** Most rebuild operations require sudo:
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

If file ownership is off:
```bash
sudo chown -R $USER:users ~/mavnezz-os
```

### 4. Flake Lock Issues

**Error:** `error: unable to download` or flake input issues

**Solution:** Update flake inputs:
```bash
cd ~/mavnezz-os
nix flake update
sudo nixos-rebuild switch --flake .#<hostname>
```

### 5. Missing Dependencies on Live ISO

**Error:** `command not found: git` or `command not found: lspci`

**Solution:** Install required tools in the live shell:
```bash
nix-shell -p git pciutils
```

### 6. Hostname Conflicts

**Error:** Configuration evaluates but build fails with a host lookup error

**Solution:** Confirm the hostname matches a directory under `devices/<form>/`:
```bash
ls devices/desktop/ devices/laptop/
```

The hostname passed to `nixos-rebuild --flake .#<name>` must exist in `nixosConfigurations` in `flake.nix`.

## Advanced Troubleshooting

### Enable Verbose Logging

```bash
sudo nixos-rebuild switch --flake .#<hostname> --verbose --show-trace
```

### Check System Logs

```bash
journalctl -xeu nixos-rebuild
journalctl -f
```

### Manual Installation Steps

If the rebuild fails completely, fall back to a manual sequence from the NixOS live ISO:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mavnezz/mavnezz-os.git ~/mavnezz-os
   cd ~/mavnezz-os
   ```

2. **Generate hardware configuration:**
   ```bash
   sudo nixos-generate-config --show-hardware-config > devices/<form>/<hostname>/hardware.nix
   ```

3. **Build and install:**
   ```bash
   export NIX_CONFIG="experimental-features = nix-command flakes"
   sudo nixos-rebuild boot --flake .#<hostname>
   ```

### Recovery from a Failed Installation

If the system won't boot after install:

1. **Boot from NixOS ISO**
2. **Mount your system:**
   ```bash
   sudo mount /dev/<root-partition> /mnt
   sudo mount /dev/<boot-partition> /mnt/boot
   ```

3. **Roll back using generations:**
   ```bash
   sudo nixos-enter --root /mnt
   nixos-rebuild list-generations
   nixos-rebuild switch --rollback
   ```

## Getting Help

### Before Asking for Help

Gather:

1. **System info:**
   ```bash
   uname -a
   lspci | grep VGA
   df -h
   free -h
   ```

2. **mavnezz-os info:**
   ```bash
   cd ~/mavnezz-os
   git log --oneline -5
   git status
   ls devices/desktop devices/laptop
   ```

3. **Error logs:** save the full error output.

## Success Checklist

After installation, verify:

- [ ] System boots into the Niri / Noctalia desktop
- [ ] Network connectivity works
- [ ] Graphics acceleration is working
- [ ] Audio works
- [ ] User account is set up correctly
- [ ] Configuration directory exists at `~/mavnezz-os`
- [ ] `dcli` command works: `dcli status`

## Prevention Tips

1. **Always verify hardware detection before building**
2. **Keep `flake.lock` updated regularly**
3. **Test builds before switching:** `nixos-rebuild build` instead of `switch`
