# Офигенная установка NixOS

## Установка с ISO

### Подготовка
1. Скачай [NixOS minimal ISO](https://nixos.org/download#nixos-iso)
2. Загрузись с флешки
3. Подключись к интернету:
```bash
sudo systemctl start NetworkManager
nmtui  # или просто воткни ethernet
```

### Установка

1. Склонируй репозиторий:
```bash
sudo nix-env -iA nixos.git
git clone https://github.com/decard2/nix.git
cd nix
```

2. Размечаем диск через disko:
```bash
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount ./nixos/disko.nix
```

3. Генерим конфиг оборудования:
```bash
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix ./nixos/
sudo mkdir -p /mnt/home/decard/
sudo cp -r ../nix /mnt/home/decard/
sudo chown -R 1000:1000 /mnt/home/decard/nix
```

4. Устанавливаем систему:
```bash
sudo nixos-install --flake .#emerald
```

5. Перезагружаемся:
```bash
reboot
```

### После установки

1. Логинимся под юзером decard (пароль по умолчанию: changeme)
2. Первым делом меняем пароль:
```bash
passwd
```
3. Все конфиги системы находятся в ~/nix
4. Profit! 🎉
