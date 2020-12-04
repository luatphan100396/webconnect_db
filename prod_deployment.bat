root_Password="die1EiphTeecah1f"
db2inst2_Password="Hec9oocu"
 
sudo -S <<< "${root_Password}" rm -r /home/db2inst2/DB 
sudo -S <<< "${root_Password}" cp -r /home/lthoanganh/DB /home/db2inst2/DB 
 
 sudo chmod -R a+rwX /home/tma-admin/test
sudo chown db2inst2 -R /home/db2inst2/DB
 
echo "${root_Password}" | sudo -S sleep 1 && sudo su - db2inst2
 
cd /home/db2inst2/DB
bash deploy_DB.bat
 

sudo rm -r /home/db2inst2/DB
 sudo cp -r /home/lthoanganh/DB /home/db2inst2/DB 

 ls -la /home/db2inst2/DB 

 ls -l /home/db2inst2/DB

 sudo chown -R /home/tma-admin/test

 sudo chmod -R a+rwX /home/tma-admin/test

 ls -la /home/tma-admin/test