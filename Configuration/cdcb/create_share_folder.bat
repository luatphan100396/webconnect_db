#rem export_folder
sudo mkdir -p /home/cdcb/export_folder
sudo mkdir -p /home/cdcb/upload_folder 

sudo groupadd SharedUsers
 
sudo chgrp -R SharedUsers /home/cdcb/export_folder
sudo chmod 777 /home/cdcb/export_folder
sudo chgrp -R SharedUsers /home/cdcb/upload_folder
sudo chmod 777 /home/cdcb/upload_folder
 

sudo usermod -a -G SharedUsers lthoanganh
sudo usermod -a -G SharedUsers db2inst1