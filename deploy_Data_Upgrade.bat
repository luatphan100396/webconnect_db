DB_Name=`sed -n '/# DB Name/p' DB_name.txt | awk '{print $1}'`;
 Error=0;
 echo "DB Name = ${DB_Name}"

 db2 connect to ${DB_Name};
 
 #rem deploy data upgrade
 echo "Deploying date upgrade" >> deploy.log;
 for f in $(find ./Data_Upgrade/ -name '*.sql' | sort -n ); do 
 
 fName=$(basename "$f")
 isRun=`db2 -x "select count(1) from dbo.DB_PATCHES where PATCH_NAME ='$fName'" `
 if [ ${isRun} -eq 0 ]
 then
	 echo $f;
	 db2 -t -f $f >> deploy.log;
	 
	 if [ $? -gt 0 ]
	   then 
		  echo "Failed to deploy script: $f" >> deploy.log; 
		  Error=1;
		  break;
	  fi
	  db2 "Insert into  dbo.DB_PATCHES(PATCH_NAME,DEPLOYED_DATE) values('$fName',CURRENT_DATE)"
  fi
 done
 
 
  if [ ${Error} -gt 0 ]  
  then 
        echo "-------------------Deploy Data upgrade failed-------------------";
	    exit;
		 
  else 
        echo "-------------------Deploy Data upgrade successfully-------------------";
  fi
 echo "-------------------Deploying Data upgrade completed-------------------" >> deploy.log;
 
  