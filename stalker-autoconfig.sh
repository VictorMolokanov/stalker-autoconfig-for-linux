#!/bin/bash

#змінні url
    Component_url=("https://drive.usercontent.google.com/download?id=1hlZIv6nUvgdToiVi0yV5Qp_EOaMYmu8I&authuser=0&confirm=t&uuid=3478597a-4ee0-4906-8206-3999f77fa8eb&at=AEz70l6n09RbXHfPp2WwGImb-6DF%3A1741178550963" \
                "https://drive.usercontent.google.com/download?id=1tOHlctaTjhNjdAHvIDi1fTsM9AYvFooH&export=download&authuser=0&confirm=t&uuid=e78fdf1a-f4fa-41cf-b1b8-e541998af1db&at=AEz70l5E7H2iL-aeIHdH-OSoSqzu%3A1741179040524" \
                "https://drive.usercontent.google.com/download?id=1uCeOIelJfX_npwfpsowK-sFCN0yi8EaU&export=download&authuser=0&confirm=t&uuid=21ff57eb-8ad9-47e1-921c-73b903e46962&at=AEz70l54LGDnMJSvTtDGEXTsLPW8%3A1741179157804")
#назви
                    Component_name=("oalinst.exe" "vcredict.exe" "Xvid.exe")
# #функція скачування
downloading() {
    Component_url=$1
    Component_name=$2
    wget --no-check-certificate "$Component_url" -O "$HOME/$Component_name"
    if [ $? -eq 0 ]; then
    TEXTMESSG="$DOWNLOADED $Component_name"
    loging_text
    else
    TEXTMESSG="$ERRORDOWNLOAD $Component_name"
    loging_text
    zenity --info --text="$Component_name $ERRORDOWNLOAD"
    fi
}
#логування в терміналі
 loging_text() {
  echo -e "\e[34m"$TEXTMESSG"\e[0m"
  }
  TEXTMESSG="СЛАВА УКРАЇНІ!"
      loging_text
#назва бібліотек
    D3DCOMPILER_43="d3dcompiler_43"
    D3DCOMPILER_47="d3dcompiler_47"
    D3DX10="d3dx10"
    D3DX10_43="d3dx10_43"
    D3DX11_43="d3dx11_43"
    D3DX9="d3dx9"
    D3DX9_43="d3dx9_43"





#початок скрипта!!!!!
#вибір мови
Language=$(zenity --list --title="Choose Language/Оберіть Мову" --radiolist \
 --column="Вибір/Choose" --column="Слава Україні/Glory To Ukraine" \
 English "English"  Ukrainian "Українська")

 if [ "$Language" == "Українська" ]; then
    #Перевірка наявності програм
    PROTONINST="LOG: protontricks на місці"
    PROTONINSTER="LOG: protontricks ВІДУСТНІЙ, Встановіть або перевстановіть пакунок!!!"
    WGETINST="LOG: Wget на місці"
    WGETINSTER="LOG: Wget ВІДУСТНІЙ, Встановіть або перевстановіть пакунок!!!"
    PROTONLAUNCHINST="LOG: protontricks-launch на місці"
    PROTONLAUNCHINSTER="LOG: protontricks-launch ВІДУСТНІЙ, Встановіть або перевстановіть пакунок!!!"
    MISSING="Відсутні або зламані пакунки"
    MISSEND="Будь-ласка встановіть або перевстановіть наявні пакунки"
    #Вибір рушія
    CHOOSEENG="Вибір рушія"
    CHOOSEEV="Вибір" #вибір усюди
    ENGINE="Рушій"
    ENGINENOCHOOSE="Не обрано рушій!"
    #Префікси стім
    PREFIXES="Префікси"
    PREFIX="Префікс"
    NOCHOOSE="Не вибрано жодного префіксу!"
    #Завантаження
    DOWNLOADED="LOG: Успішно Завантажено"
    ERRORDOWNLOAD="LOG: Не вдалось Завантажити"
    #інсталяція d3dcompiler-ів
    INSTALLEDD="Встановленно Бібліотеку"
    #фінал
    FINALACORD="Було успішно налаштовано, ваш мод "
elif [ "$Language" == "English" ]; then
    #Перевірка наявності програм
    PROTONINST="LOG: protontricks installed"
    PROTONINSTER="LOG: ARE MISSING, Please Install or Reinstall this package!!!"
    WGETINST="LOG: Wget installed"
    WGETINSTER="LOG: Wget ARE MISSING, Please Install or Reinstall this package!!!"
    PROTONLAUNCHINST="LOG: installed"
    PROTONLAUNCHINSTER="LOG: protontricks-launch ARE MISSING, Please Install or Reinstall this package!!!"
    MISSING="Missing or broken packages"
    MISSEND="Please install or reinstall thi packages"
    #Вибір рушія
    CHOOSEENG="Choose Engine"
    CHOOSEEV="Choose" #вибір усюди
    ENGINE="Engine"
    ENGINENOCHOOSE="Engine aren't Choosen!"
    #Префікси стім
    PREFIXES="Prefixes"
    PREFIX="Games"
    NOCHOOSE="Didn't Choosen Prefix!"
    #Завантаження
    DOWNLOADED="LOG: Succesful Downloaded"
    ERRORDOWNLOAD="LOG: Can't download"
        #інсталяція d3dcompiler-ів
    INSTALLEDD="Installed library"
    #Фінальний акорд
    FINALACORD="Your Mod should work "
elif [ -z "$Language" ]; then
    zenity --error --text="Ви не обрали жодної мови!/No Language Choosen!"
    exit 1
 #перевірка чи є програми:
fi

 if ! command -v protontricks &> /dev/null; then
    ERROR00="protontricks"
    TEXTMESSG="$PROTONINSTER"
    loging_text
    else
    TEXTMESSG="$PROTONINST"
    loging_text
 fi
 if ! command -v wget &> /dev/null; then
    ERROR01="wget"
        TEXTMESSG="$WGETINSTER"
    loging_text
    else
    TEXTMESSG="$WGETINST"
    loging_text
 fi
 if ! command -v protontricks-launch &> /dev/null; then
    ERROR02="protontricks-launch"
        TEXTMESSG="$PROTONLAUNCHINSTER"
    loging_text
    else
    TEXTMESSG="$PROTONLAUNCHINST"
    loging_text
 fi

 if [ "$ERROR00" == "protontricks" ] || [ "$ERROR01" == "wget" ] || [ "$ERROR02" == "protontricks-launch" ]; then
        zenity --error --text "$MISSING $ERROR00, $ERROR01, $ERROR02 $MISSEND"
    else
    echo "все добре"
        fi

 #ВИБІР РУШІЯ

Engine=$(zenity --list --title="$CHOOSEENG" --radiolist \
 --column="$CHOOSEEV" --column="$ENGINE" \
 Proton "Proton"  Wine "Wine")

 if [ "$Engine" == "Proton" ]; then
proton_prefix=$(protontricks -l | grep -E "Non-Steam|S.T.A.L.K.E.R.")
selected=$(echo "$proton_prefix" | zenity --list --title="$PREFIXES" --column="$PREFIX" --height=400 --width=600 )
proton_id=$(echo "$selected" | grep -oP '\(\K\d+(?=\))')

if [ -z "$proton_id" ]; then
 zenity --error --text="$NOCHOOSE"
    exit 1
 fi




#саме скачування
   for i in "${!Component_url[@]}"; do
      downloading "${Component_url[$i]}" "${Component_name[$i]}"
 done
    #інсталяція драйверів
    protontricks-launch --appid $proton_id "$HOME/oalinst.exe"
    protontricks-launch --appid $proton_id "$HOME/vcredict.exe"
    protontricks-launch --appid $proton_id "$HOME/Xvid.exe"
    #інсталяція компіляторів
        protontricks $proton_id d3dcompiler_43
    TEXTMESSG="$INSTALLEDD $D3DCOMPILER_43"
    loging_text
    protontricks $proton_id d3dcompiler_47
        TEXTMESSG="$INSTALLEDD $D3DCOMPILER_47"
    loging_text
    protontricks $proton_id d3dx10
        TEXTMESSG="$INSTALLEDD $D3DX10"
    loging_text
    protontricks $proton_id d3dx10_43
        TEXTMESSG="$INSTALLEDD $D3DX10_43"
    loging_text
    protontricks $proton_id d3dx11_43
        TEXTMESSG="$INSTALLEDD $D3DX11_43"
    loging_text
    protontricks $proton_id d3dx9
        TEXTMESSG="$INSTALLEDD $D3DX9"
    loging_text
    protontricks $proton_id d3dx9_43
        TEXTMESSG="$INSTALLEDD $D3DX9_43"
    loging_text
    #Фінальний акорд, привітання що мод працює
    Gamefinal=$( echo "$selected" | sed -e 's/Non-Steam shortcut:[[:space:]]*//' -e 's/[[:space:]]*(.*//')
    zenity --info --text "$FINALACORD $Gamefinal"
    notifg
 elif [ "$Engine" == "Wine" ]; then
    TEXTMESSG="НЕ ГОТОВЕ/DIDNT READY"
    loging_text
 elif [ -z "$Engine" ]; then
    zenity --error --text="$ENGINENOCHOOSE"
    exit 1
fi
