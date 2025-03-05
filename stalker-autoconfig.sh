#!/bin/bash

# Запит пароля адміністратора через Zenity
PASSWORD=$(zenity --entry --title="Пароль адміністратора" --text="Будь ласка, введіть пароль адміністратора для продовження:" --hide-text)
if ! command -v zenity &> /dev/null
then
    # Якщо zenity не знайдено, вивести сповіщення
    notify-send "Zenity не знайдено" "Будь ласка, встановіть zenity за допомогою команди: sudo apt install zenity"
    exit 1
fi

# Перевірка пароля
echo $PASSWORD | sudo -S true
if [ $? -ne 0 ]; then
    zenity --error --text="Невірний пароль. Скрипт завершено."
    exit 1
fi

# Перевірка наявності protontricks
if ! command -v protontricks &> /dev/null; then
    zenity --info --text="protontricks не знайдено. Встановлюю..."

    # Визначення пакувального менеджера
    if command -v apt &> /dev/null; then
        INSTALL_CMD="sudo apt update && sudo apt install protontricks -y"
        MANAGER="apt"
    elif command -v dnf &> /dev/null; then
        INSTALL_CMD="sudo dnf install protontricks -y"
        MANAGER="dnf"
    elif command -v pacman &> /dev/null; then
        INSTALL_CMD="sudo pacman -S protontricks --noconfirm"
        MANAGER="pacman"
    elif command -v zypper &> /dev/null; then
        INSTALL_CMD="sudo zypper install protontricks"
        MANAGER="zypper"
    elif command -v yum &> /dev/null; then
        INSTALL_CMD="sudo yum install protontricks -y"
        MANAGER="yum"
    elif command -v snap &> /dev/null; then
        INSTALL_CMD="sudo snap install protontricks"
        MANAGER="snap"
    elif command -v flatpak &> /dev/null; then
        INSTALL_CMD="sudo flatpak install flathub com.github.GitHub.Protontricks -y"
        MANAGER="flatpak"
    else
        zenity --error --text="Не вдалося визначити пакувальний менеджер. Будь ласка, встановіть protontricks вручну."
        exit 1
    fi

    # Підтвердження користувача для встановлення
    if zenity --question --title="Підтвердження" --text="Використовувати пакетний менеджер $MANAGER для встановлення protontricks?" ; then
        # Виконання команди для встановлення
        eval $INSTALL_CMD
        if [ $? -eq 0 ]; then
            zenity --info --text="protontricks успішно встановлено!"
        else
            zenity --error --text="Не вдалося встановити protontricks!"
            exit 1
        fi
    else
        zenity --error --text="Встановлення скасовано користувачем."
        exit 1
    fi
fi

# Продовження роботи скрипта
(zenity --info --text="Будь-ласка, якщо ваш мод базується на чистому рушії ТЧ, то фікс це Proton 5, або якщо це мод поверх оригінальної гри інсталювати *піратський* ТЧ і грати через wine...")


#!/bin/bash

# Функція для завантаження компонентів

download_component() {
    COMPONENT_URL=$1
    COMPONENT_NAME=$2

    # Завантаження компонента
    wget --no-check-certificate "$COMPONENT_URL" -O "$HOME/$COMPONENT_NAME"

    # Перевірка на успішне завантаження
    if [ $? -eq 0 ]; then
        zenity --info --text="Компонент $COMPONENT_NAME успішно завантажено."
    else
        zenity --error --text="Не вдалося завантажити компонент $COMPONENT_NAME."
        exit 1
    fi
}

# Запит на вибір між Proton або Wine
SELECTED_ENGINE=$(zenity --list --title="Вибір між Proton та Wine" --radiolist \
    --column="Вибір" --column="Двигун" \
    TRUE "Proton" FALSE "Wine --не готовий")

if [ "$SELECTED_ENGINE" == "Proton" ]; then
    # Перевірка наявності Protontricks

    # Перевірка наявності префіксів Proton
    PREFIXES=$(protontricks -l)

    # Фільтрація для "Non-Steam" і "S.T.A.L.K.E.R."
    FILTERED_PREFIXES=$(echo "$PREFIXES" | grep -E "Non-Steam|S.T.A.L.K.E.R.")

    if [ -z "$FILTERED_PREFIXES" ]; then
        zenity --error --text="Не знайдено відповідних префіксів для Proton (Non-Steam або S.T.A.L.K.E.R.)."
        exit 1
    fi

    # Вибір префіксу з фільтру
    SELECTED_PREFIX=$(echo "$FILTERED_PREFIXES" | zenity --list --title="Вибір префіксу Proton" --column="Префікс" --height=400 --width=600)

    # Витягуємо числове значення в дужках
    PREFIX_ID=$(echo "$SELECTED_PREFIX" | grep -oP '\(\K\d+(?=\))')

    # Вивід для перевірки
    echo "PREFIX_ID=$PREFIX_ID"

    if [ -z "$PREFIX_ID" ]; then
        zenity --error --text="Не вибрано жодного префіксу!"
        exit 1
    fi

# Скачування необхідних компонентів
    COMPONENTS=("https://drive.usercontent.google.com/download?id=1hlZIv6nUvgdToiVi0yV5Qp_EOaMYmu8I&authuser=0&confirm=t&uuid=3478597a-4ee0-4906-8206-3999f77fa8eb&at=AEz70l6n09RbXHfPp2WwGImb-6DF%3A1741178550963" \
                "https://drive.usercontent.google.com/download?id=1tOHlctaTjhNjdAHvIDi1fTsM9AYvFooH&export=download&authuser=0&confirm=t&uuid=e78fdf1a-f4fa-41cf-b1b8-e541998af1db&at=AEz70l5E7H2iL-aeIHdH-OSoSqzu%3A1741179040524" \
                "https://drive.usercontent.google.com/download?id=1uCeOIelJfX_npwfpsowK-sFCN0yi8EaU&export=download&authuser=0&confirm=t&uuid=21ff57eb-8ad9-47e1-921c-73b903e46962&at=AEz70l54LGDnMJSvTtDGEXTsLPW8%3A1741179157804")
    COMPONENT_NAMES=("olainst.exe" "vcredict.exe" "Xvid.exe")

    for i in "${!COMPONENTS[@]}"; do
        download_component "${COMPONENTS[$i]}" "${COMPONENT_NAMES[$i]}"
    done

    # Інсталяція компонентів через Protontricks
    for COMPONENT in "${COMPONENT_NAMES[@]}"; do
        zenity --info --text="Інсталюємо компонент: $COMPONENT"
        protontricks-launch --appid $PREFIX_ID "$HOME/$COMPONENT"
    done
     zenity --info --text="Інсталюємо DLL бібліотеки, будь-ласка дочекайтесь завершення інсталяції"
    # Додавання необхідних бібліотек DirectX
    protontricks $PREFIX_ID d3dcompiler_43
    protontricks $PREFIX_ID d3dcompiler_47
    protontricks $PREFIX_ID d3dx10
    protontricks $PREFIX_ID d3dx10_43
    protontricks $PREFIX_ID d3dx11_43
    protontricks $PREFIX_ID d3dx9
    protontricks $PREFIX_ID d3dx9_43

    FINAL_ACORD=$( echo "$SELECTED_PREFIX" | sed -e 's/Non-Steam shortcut:[[:space:]]*//' -e 's/[[:space:]]*(.*//')
    zenity --info --text="Налштування завершено! можете грати у ваш $FINAL_ACORD"

elif [ "$SELECTED_ENGINE" == "Wine --не готовий" ]; then
         zenity --error --text="Будь-ласка допишіть код, я німагу... Відкрийте цей файлік у текстовому редакторі і допишіть код який позначений після цього рядку $LINENO, правки надішліть мені на мій гітхаб"
   :<< 'END'
   if ! command -v wine &> /dev/null; then
        zenity --error --text="Wine не знайдено! Встановіть будь-ласка Wine..."
    fi
    # Перевірка наявності protontricks
    if ! command -v winetricks &> /dev/null; then
    zenity --info --text="winetricks не знайдено. Встановлюю..."
fi
    # Визначення пакувального менеджера
    if command -v apt &> /dev/null; then
        INSTALL_CMD="sudo apt update && sudo apt install protontricks -y"
        MANAGER="apt"
    elif command -v dnf &> /dev/null; then
        INSTALL_CMD="sudo dnf install protontricks -y"
        MANAGER="dnf"
    elif command -v pacman &> /dev/null; then
        INSTALL_CMD="sudo pacman -S protontricks --noconfirm"
        MANAGER="pacman"
    elif command -v zypper &> /dev/null; then
        INSTALL_CMD="sudo zypper install protontricks"
        MANAGER="zypper"
    elif command -v yum &> /dev/null; then
        INSTALL_CMD="sudo yum install protontricks -y"
        MANAGER="yum"
    elif command -v snap &> /dev/null; then
        INSTALL_CMD="sudo snap install protontricks"
        MANAGER="snap"
    elif command -v flatpak &> /dev/null; then
        INSTALL_CMD="sudo flatpak install flathub com.github.GitHub.Protontricks -y"
        MANAGER="flatpak"
    else
        zenity --error --text="Не вдалося визначити пакувальний менеджер. Будь ласка, встановіть protontricks вручну."
        exit 1
    fi
        # Підтвердження користувача для встановлення
    if zenity --question --title="Підтвердження" --text="Використовувати пакетний менеджер $MANAGER для встановлення winetricks?" ; then
        # Виконання команди для встановлення
        eval $INSTALL_CMD
        if [ $? -eq 0 ]; then
            zenity --info --text="protontricks успішно встановлено!"
        else
            zenity --error --text="Не вдалося встановити protontricks!"
            exit 1
        fi
    else
        zenity --error --text="Встановлення скасовано користувачем."
        exit 1
    fi
    # Перевірка наявності префіксів Wine
    WINE_PREFIXES=$(ls ~/.wineprefixes)

    if [ -z "$WINE_PREFIXES" ]; then
        zenity --error --text="Не знайдено жодних префіксів Wine."
        exit 1
    fi

    # Вибір префіксу Wine
    SELECTED_WINE_PREFIX=$(echo "$WINE_PREFIXES" | zenity --list --title="Вибір префіксу Wine" --column="Префікс" --height=400)

    # Якщо префікс не знайдено, створюємо новий
    if [ -z "$SELECTED_WINE_PREFIX" ]; then
        zenity --info --text="Створюємо новий префікс Wine..."
        wineprefix create ~/.wineprefixes/new_prefix
        SELECTED_WINE_PREFIX="new_prefix"
    fi

    # Скачування необхідних компонентів
    COMPONENTS=("https://drive.google.com/uc?export=download&id=1hlZIv6nUvgdToiVi0yV5Qp_EOaMYmu8I" \
                "https://drive.google.com/uc?export=download&id=1tOHlctaTjhNjdAHvIDi1fTsM9AYvFooH" \
                "https://drive.google.com/uc?export=download&id=1uCeOIelJfX_npwfpsowK-sFCN0yi8EaU")
    COMPONENT_NAMES=("vcredist.exe" "wine_mono.exe" "oalinst.exe")

    for i in "${!COMPONENTS[@]}"; do
        download_component "${COMPONENTS[$i]}" "${COMPONENT_NAMES[$i]}"
    done

    # Інсталяція компонентів через Wine
    for COMPONENT in "${COMPONENT_NAMES[@]}"; do
        zenity --info --text="Інсталюємо компонент: $COMPONENT"
        wine $SELECTED_WINE_PREFIX/drive_c/"tmp/$COMPONENT"
    done

    winetricks $SELECTED_WINE_PREFIX d3dcompiler_43
    winetricks $SELECTED_WINE_PREFIX d3dcompiler_47
    winetricks $SELECTED_WINE_PREFIX d3dx10
    winetricks $SELECTED_WINE_PREFIX d3dx10_43
    winetricks $SELECTED_WINE_PREFIX d3dx11_43
    winetricks $SELECTED_WINE_PREFIX d3dx9
    winetricks $SELECTED_WINE_PREFIX d3dx9_43

    zenity --info --text="Інсталяція завершена!"
END
else
    zenity --error --text="Невідомий вибір!"
    exit 1
fi
