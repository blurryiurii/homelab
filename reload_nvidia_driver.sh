#!/usr/bin/env bash
set -euo pipefail

echo "Stopping NVIDIA persistence daemon..."
sudo systemctl stop nvidia-persistenced || true

echo "Unloading NVIDIA modules..."
sudo modprobe -r nvidia_drm || true
sudo modprobe -r nvidia_modeset || true
sudo modprobe -r nvidia_uvm || true
sudo modprobe -r nvidia || true

echo "Unloading nouveau if it claimed the GPU..."
if lsmod | grep -q '^nouveau'; then
    sudo modprobe -r nouveau
fi

echo "Loading NVIDIA modules..."
sudo modprobe nvidia
sudo modprobe nvidia_uvm
sudo modprobe nvidia_modeset
sudo modprobe nvidia_drm

echo
echo "Driver version:"
cat /proc/driver/nvidia/version

echo
echo "Testing GPU:"
nvidia-smi

echo
echo "Done."