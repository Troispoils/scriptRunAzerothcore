#!/bin/bash

DIRINSTALL='/home/troispoils/Documents/source/azerothserv'
DIRSOURCE='/home/troispoils/Documents/source/azerothcore'
DIRPARENT='/home/troispoils/Documents/source'


recup_source () {
        cd $DIRPARENT
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
        cd $DIRSOURCE
        git pull
        compiling
}

compiling () {
        echo "Comencer la compilation?";
        read
        cd $DIRSOURCE
        rm -r build
        mkdir build
        cd "build"
        cmake ../ -DCMAKE_INSTALL_PREFIX=$DIRINSTALL -DCMAKE_C_Compiler=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DTOOLS=0 -DSCRIPTS=1
        make -j 4
        make install
}

startup () {
	echo "Starting server...";
	cd $DIRINSTALL
	screen -dmS login ./auhtserver
	screen -dmS world ./worldserver
}

stopserv () {
	idw=$(pidof worldserver)
	idl=$(pidof authserver)
	
	echo "Verification que le server et pas lancer...";
	
	if [ $idw != "" ] ;then
		echo "World present, kill du world.";
		kill $idw
	else
		echo "World non present";
	fi
	if [ $idl != "" ] ;then
		echo "Auth present, kill du auth.";
		kill $idl
	else
		echo "Auth non present";
	fi
}

stopserv

if [ -d $DIRSOURCE ] ;then
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
        cd $DIRPARENT
        recup_source nowipe
fi

## commande launch ##
# screen -dmS login ./auhtserver
# screen -dmS world ./worldserver
# pidof worldserver ## verifier si le server est en ligne