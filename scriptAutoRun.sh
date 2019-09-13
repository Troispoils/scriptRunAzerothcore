#!/bin/bash

DIRINSTALL='/home/troispoils/Documents/source/azerothserv'



recup_source () {
        cd "/home/troispoils/Documents/source"
        if [ $1 = "wipe" ] ;then
                echo "Supression de l'ancienne source :";
                sudo rm -r azerothcore
        else
                echo "Clonage de la source :";
        fi

        git clone https://github.com/azerothcore/azerothcore-wotlk.git azerothcore
        compiling
}

maj_source () {
        cd "/home/troispoils/Documents/source/azerothcore/"
        git pull
        compiling
}

compiling () {
        echo "Comencer la compilation?";
        read
        cd "/home/troispoils/Documents/source/azerothcore"
        rm -r build
        mkdir build
        cd "build"
        cmake ../ -DCMAKE_INSTALL_PREFIX=$DIRINSTALL -DCMAKE_C_Compiler=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DTOOLS=0 -DSCRIPTS=1
        make -j 4
        make install
}

if [ -d "/home/troispoils/Documents/source/azerothcore" ] ;then
        echo "Le dossier existe deja.";
        echo "1 - Update Source";
        echo "2 - Wipe and News";
        read choix
        if [ $choix = "1" ] ;then
                maj_source
        else
                recup_source wipe
        fi
else
        echo "Le dossier existe pas !";
        echo "Creation de la source et du dossier.";
        read
        cd "/home/troispoils/Documents/source"
        recup_source nowipe
fi

## commande launch ##
# screen -dmS login ./auhtserver
# screen -dmS world ./worldserver