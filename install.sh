#!/bin/sh
set -e

# Устанавливаем локаль
export LANG=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8

# Наша крутая ASCII-арт заставка
cat << "EOF"

███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗
████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝
██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗
██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║
██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝

🚀 Погнали настраивать систему, братан!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Проверяем права рута
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Нужны права рута! Запусти через sudo"
    exit 1
fi

# Проверяем что мы в NixOS
if [ ! -f /etc/NIXOS ]; then
    echo "❌ Это не NixOS! Ты куда меня пихаешь?"
    exit 1
fi

# Функция для настройки WiFi
setup_wifi() {
    echo "📡 Настраиваем WiFi..."

    # Запускаем wpa_supplicant
    systemctl start wpa_supplicant

    # Ждем пока интерфейс поднимется
    sleep 2

    # Сканируем сети
    echo "🔍 Ищем доступные сети..."
    iwctl station wlan0 scan
    sleep 2

    # Показываем список сетей
    echo "\n📶 Доступные сети:"
    iwctl station wlan0 get-networks

    # Спрашиваем имя сети
    printf "\n💭 Введи имя WiFi сети: "
    read -r SSID

    # Подключаемся (iwctl сам спросит пароль)
    echo "🔌 Подключаемся к $SSID..."
    iwctl station wlan0 connect "$SSID"

    # Ждем соединения
    echo "⏳ Ждем подключения..."
    sleep 5
}

# Проверяем интернет
if ! ping -c 1 google.com >/dev/null 2>&1; then
    echo "❌ Нет интернета!"
    echo "💡 Давай настроим WiFi..."
    setup_wifi

    # Проверяем еще раз
    if ! ping -c 1 google.com >/dev/null 2>&1; then
        echo "❌ Все равно нет интернета. Проверь подключение и попробуй снова."
        exit 1
    fi
fi

echo "🔧 Ставим нужные тулзы..."
nix-shell -p git nushell --run "\
    echo '📦 Качаем конфиг...' && \
    git clone https://github.com/decard2/nix /tmp/nixos-config && \
    cd /tmp/nixos-config && \
    echo '⚙️  Настраиваем систему...' && \
    ./install.nu
"

echo "
✨ Всё готово, братишка!
💡 Перезагрузись и наслаждайся новой системой!
   Если что-то пойдет не так - пиши в issues, поможем!
"
