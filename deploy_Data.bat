 DB_Name=`sed -n '/# DB Name/p' DB_name.txt | awk '{print $1}'`;
 Error=0;
 echo "DB Name = ${DB_Name}"

 db2 connect to ${DB_Name};
  
 #rem deploy data
 echo "Deploying data" >> deploy.log;
 for f in $(find ./Data/ -name '*.sql' | sort -n ); do 
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
        echo "-------------------Deploy data failed---------------------";
	    exit;
		 
  else 
        echo "-------------------Deploy data successfully-------------------";
  fi
 echo "-------------------Deploying data completed-------------------" >> deploy.log;
 