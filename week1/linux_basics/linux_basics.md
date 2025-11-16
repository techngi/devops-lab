## Linux Network Commands with Outputs

---

### 1️⃣ View IP Address

```bash
ip a
```
![ifconfig screenshot](../screenshots/1.png)

### 1️⃣ Check the routing table
```bash
ip route
```
![ifconfig screenshot](../screenshots/2.png)

### 1️⃣ Check connectivity
```bash
ping google.com
```
![ifconfig screenshot](../screenshots/3.png)

### 1️⃣ Name Resolution
```bash
nslookup google.com
dig google.com
```
![ifconfig screenshot](../screenshots/4.png)
![ifconfig screenshot](../screenshots/5.png)

### 1️⃣ Download URL headers
```bash
curl -I www.google.com
```
![ifconfig screenshot](../screenshots/6.png)

### 1️⃣ Permit port 22 and 80 on host firewall
```bash
sudo ufw status
sudo ufw allow from any port 22
sudo ufw allow from any port 80
sudo ufw enable
sudo ufw status
```
![ifconfig screenshot](../screenshots/7.png)

![ifconfig screenshot](../screenshots/8.png)
