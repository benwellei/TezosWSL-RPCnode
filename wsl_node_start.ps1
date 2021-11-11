wsl.exe sudo /etc/init.d/ssh start
$wsl_ip = (wsl hostname -I).trim()
Write-Host "WSL Machine IP: ""$wsl_ip"""
netsh interface portproxy add v4tov4 listenport=8732 connectport=8732 connectaddress=$wsl_ip
wsl /mnt/c/Users/haasb/desktop/node.sh
