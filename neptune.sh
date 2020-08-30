#!/bin/bash
echo "##################subdomain enumeration#####################"
#exec findomain -t $1 | tee $1_findomain.txt &	
exec amass enum --passive -d $1 | tee $1_amass.txt 
exec subfinder -d $1 -v | tee $1_subfinder.txt 
exec python3 /root/tools/github-subdomains/github-subdomains.py -t "59fcb96fd556bcaeb5066a7d7a3e07f3650b4a3c" -d $1 | tee $1_githubsubs.txt
echo "#####################bufferover#####################"
exec curl -s https://dns.bufferover.run/dns?q=.$1 |jq -r .FDNS_A[]|cut -d',' -f2|sort -u | tee $1_bufferover.txt
exec cat $1_* | sort |grep -E .*\.$1$|sed 's/Target ==> //g'| uniq | tee $1_uniq.txt 
echo "#####################unique domains#####################"
exec cat $1_uniq.txt | wc -l
echo "#######################httprobe#########################"
exec cat $1_uniq.txt| httprobe | tee $1_httprobe.txt
