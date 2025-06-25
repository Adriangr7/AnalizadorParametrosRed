#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
	echo -e "\n$redColour[+] Saliendo del script...$endColour\n"
	exit 0
}

trap ctrl_c INT

function helpPannel(){
	echo -e "\n$yellowColour Panel de ayuda$endColour"
	echo -e "\n$yellowColour d)$endColour$turquoiseColour Direccion IPv6 del servidor DNS$endColour"
	echo -e "\n$yellowColour u)$endColour$turquoiseColour Dominios a analizar$endColour\n"
}

function analizarDNS(){

DNS=$1
echo -e "\n$yellowColour[+]$endColour$blueColour No se detectó caché DNS local. No es necesario vaciarla.$endColour\n"

echo -e "$yellowColour[+]$endColour$blueColour Estableciendo servidor DNS temporalmente en $greenColour$DNS$endColour$blueColour...$endColour\n"
if [ -L /etc/resolv.conf ]; then
    echo "$redColour[i]$endColour$greenColour /etc/resolv.conf es un enlace simbólico. Se reemplazará temporalmente.$endColour"
    sudo rm /etc/resolv.conf
fi
#sudo tee /etc/resolv.conf > /dev/null
sudo bash -c "echo 'nameserver $DNS' > /etc/resolv.conf"

echo -e "$yellowColour[+]$endColour$blueColour Comprobando el contenido actual de $greenColour/etc/resolv.conf$endColour$blueColour...$endColour\n"

#Latencia media=$(ping6 www.google.com -c 1 | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $2}')
#Latencia maxima=$(ping6 www.google.com -c 1 | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $3}')
#Latencia minima=$(ping6 www.google.com -c 1 | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $1}')

echo -e "$yellowColour[+]$endColour$blueColour Medicion de la Latencia a servidor DNS con IP$endColour $greenColour$DNS$endColour$blueColour... $endColour\n"
Result=$(ping6 $DNS -c 100 | tail -n 5)
Latencia_minima=$(echo "$Result" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $1}')
Latencia_maxima=$(echo "$Result" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $3}')
Latencia_media=$(echo "$Result" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $2}')
echo -e "$purpleColour La latencia minima es $endColour$greenColour$Latencia_minima$endColour\n"
echo -e "$purpleColour La latencia maxima es $endColour$greenColour$Latencia_maxima$endColour\n"
echo -e "$purpleColour La latencia media es $endColour$greenColour$Latencia_media$endColour\n"

Perdida=$(echo "$Result" | tail -n 2 | awk -F 'received,' '{print $2}' | awk -F ',' '{print $1}')
echo -e "$purpleColour El porcentaje de perdida de paquetes es:$endColour$greenColour$Perdida$endColour\n"
}

function analizarDominio1(){

Dominio1=$1
echo -e "$yellowColour[+]$endColour$blueColour Tiempo de resolucion DNS del Dominio $endColour$greenColour$Dominio1$endColour\n"
Resolucion=$(dig -6 $Dominio1 AAAA)
#echo "$Resolucion"
IP=$(echo "$Resolucion" | tail -n 6 | head -n 1 | awk '{print $NF}')
echo -e "$purpleColour La IP para el dominio$endColour $greenColour$Dominio1$endColour$blueColour es: $endColour$greenColour$IP$endColour\n"
Tiempo=$(echo "$Resolucion" | tail -n 4 | head -n 1 | awk -F ':' '{print $2}')
#echo -e "$Tiempo"
echo -e "$purpleColour El tiempo de resolucion DNS para este dominio es:$endColour$greenColour$Tiempo$endColour\n"

echo -e "$yellowColour[+]$endColour$blueColour Calculo de la latencia de la IP del dominio introducido...\n$endColour"
Resultado=$(ping6 $IP -c 100 | tail -n 5)
Latencia_minima2=$(echo "$Resultado" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $1}')
Latencia_maxima2=$(echo "$Resultado" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $3}')
Latencia_media2=$(echo "$Resultado" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $2}')
echo -e "$purpleColour La latencia minima es $endColour$greenColour$Latencia_minima2$endColour\n"
echo -e "$purpleColour La latencia maxima es $endColour$greenColour$Latencia_maxima2$endColour\n"
echo -e "$purpleColour La latencia media es $endColour$greenColour$Latencia_media2$endColour\n"

Perdida2=$(echo "$Resultado" | tail -n 2 | awk -F 'received,' '{print $2}' | awk -F ',' '{print $1}')
echo -e "$purpleColour El porcentaje de perdida de paquetes es:$endColour$greenColour$Perdida2$endColour\n"
}

function analizarDominio2(){
echo -e "$yellowColour[+]$endColour$blueColour Tiempo de resolucion DNS del Dominio $endColour$greenColour$Dominio2$endColour\n"
Resolucion2=$(dig -6 $Dominio2 AAAA)
#echo "$Resolucion2"
IP2=$(echo "$Resolucion2" | tail -n 6 | head -n 1 | awk '{print $NF}')
echo -e "$purpleColour La IP para el dominio$endColour $greenColour$Dominio2$endColour$blueColour es: $endColour$greenColour$IP2$endColour\n"
Tiempo2=$(echo "$Resolucion2" | tail -n 4 | head -n 1 | awk -F ':' '{print $2}')
#echo -e "$Tiempo2"
echo -e "$purpleColour El tiempo de resolucion DNS para este dominio es:$endColour$greenColour$Tiempo2$endColour\n"

echo -e "$yellowColour[+]$endColour$blueColour Calculo de la latencia de la IP del dominio introducido...\n$endColour"
Resultado2=$(ping6 $IP2 -c 100 | tail -n 5)
Latencia_minima3=$(echo "$Resultado2" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $1}')
Latencia_maxima3=$(echo "$Resultado2" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $3}')
Latencia_media3=$(echo "$Resultado2" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $2}')
echo -e "$purpleColour La latencia minima es $endColour$greenColour$Latencia_minima3$endColour\n"
echo -e "$purpleColour La latencia maxima es $endColour$greenColour$Latencia_maxima3$endColour\n"
echo -e "$purpleColour La latencia media es $endColour$greenColour$Latencia_media3$endColour\n"

Perdida3=$(echo "$Resultado2" | tail -n 2 | awk -F 'received,' '{print $2}' | awk -F ',' '{print $1}')
echo -e "$purpleColour El porcentaje de perdida de paquetes es:$endColour$greenColour$Perdida3$endColour\n"
}

function analizarDominio3(){
echo -e "$yellowColour[+]$endColour$blueColour Tiempo de resolucion DNS del Dominio $endColour$greenColour$Dominio3$endColour\n"
Resolucion3=$(dig -6 $Dominio3 AAAA)
#echo "$Resolucion3"
IP3=$(echo "$Resolucion3" | tail -n 6 | head -n 1 | awk '{print $NF}')
echo -e "$purpleColour La IP para el dominio$endColour $greenColour$Dominio3$endColour$blueColour es: $endColour$greenColour$IP3$endColour\n"
Tiempo3=$(echo "$Resolucion3" | tail -n 4 | head -n 1 | awk -F ':' '{print $2}')
#echo -e "$Tiempo3"
echo -e "$purpleColour El tiempo de resolucion DNS para este dominio es:$endColour$greenColour$Tiempo3$endColour\n"

echo -e "$yellowColour[+]$endColour$blueColour Calculo de la latencia de la IP del dominio introducido...\n$endColour"
Resultado3=$(ping6 $IP3 -c 100 | tail -n 5)
Latencia_minima4=$(echo "$Resultado3" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $1}')
Latencia_maxima4=$(echo "$Resultado3" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $3}')
Latencia_media4=$(echo "$Resultado3" | tail -n 1 | awk -F '=' '{print $2}' | awk -F '/' '{print $2}')
echo -e "$purpleColour La latencia minima es $endColour$greenColour$Latencia_minima4$endColour\n"
echo -e "$purpleColour La latencia maxima es $endColour$greenColour$Latencia_maxima4$endColour\n"
echo -e "$purpleColour La latencia media es $endColour$greenColour$Latencia_media4$endColour\n"

Perdida4=$(echo "$Resultado3" | tail -n 2 | awk -F 'received,' '{print $2}' | awk -F ',' '{print $1}')
echo -e "$purpleColour El porcentaje de perdida de paquetes es:$endColour$greenColour$Perdida4$endColour\n"
}

declare -i parameter_counter=0

while getopts "d:u:h" arg; do
	case $arg in
		d) DNS=$OPTARG; let parameter_counter+=1;;
		u) Dominio1=$OPTARG
		   shift $((OPTIND -1))
		   Dominio2=$1
		   Dominio3=$2
		   let parameter_counter+=2;;
		h) helpPannel exit 0;;
	esac
done

if [ $parameter_counter -eq 1 ]; then
	analizarDNS $DNS
elif [ $parameter_counter -eq 3 ]; then
	analizarDNS $DNS
	analizarDominio1 $Dominio1

	if [[ -n "$Dominio2" ]]; then
		analizarDominio2
	fi

	if [[ -n "$Dominio3" ]]; then
                analizarDominio3
     	fi
else
	helpPannel
fi

