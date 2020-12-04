 DB_Name=`sed -n '/# DB Name/p' DB_name.txt | awk '{print $1}'`;
 Error=0;
 echo "DB Name = ${DB_Name}"

 db2 connect to ${DB_Name} >> deploy.log;
 
 #rem deploy DM
 echo "Deploying DM" >> deploy.log;
 for f in $(find ./DM/ -name '*.sql' | sort -n ); do 
 echo $f;
 db2 -t -f $f >> deploy.log; 
 
 if [ $? -gt 0 ]
   then 
	  echo "Failed to deploy script: $f" >> deploy.log; 
	  Error=1;
	  break;
  fi
 done
 
 if [ ${Error} -gt 0 ]  
  then 
        echo "-------------------Deploy DM failed-------------------";
	    exit;
		 
  else 
        echo "-------------------Deploy DM successfully-------------------";
  fi
 
 echo "-------------------Deploying DM completed-------------------" >> deploy.log;
  