DB_Name=`sed -n '/# DB Name/p' DB_name.txt | awk '{print $1}'`;
Error=0;

 echo "DB Name = ${DB_Name}"
 db2 connect to ${DB_Name};
  
 #add termination characters : @
 for f in $(find ./View_SP_Synonym/ -name '*.sql'  ); do echo "@">> $f;done
  
 #rem deploy functions
 echo "Deploying functions" >> deploy.log;
 echo $?
 for f in $(find ./View_SP_Synonym/1.functions/ -name '*.sql' | sort -n  ); do 
 echo $f;
 db2 -td@ -f $f >> deploy.log; 
 if [ $? -gt 0 ]
   then 
	  echo "Failed to deploy function: $f" >> deploy.log; 
	  Error=1;
	  break;
  fi
   
 done
 
 if [ ${Error} -gt 0 ]  
  then 
        echo "Deploy functions failed";
	    exit;
		 
  else 
        echo "Deploy functions successfully";
  fi
 
 echo "Deploying functions completed" >> deploy.log;
 
 #rem deploy procedures
 echo "Deploying store procedures" >> deploy.log;
 for f in $(find ./View_SP_Synonym/3.store_procedures/ -name '*.sql' | sort -n  ); do 
 echo $f;
 db2 -td@ -f $f >> deploy.log;
   if [ $? -gt 0 ]
   then 
	  echo "Failed to deploy store procedure: $f" >> deploy.log; 
	  Error=1;
	  break;
   fi
 done

 if [ ${Error} -gt 0 ]  
  then 
        echo "-------------------Deploy store procedures failed-------------------";
	    exit;
  else 
        echo "-------------------Deploy store procedures successfully-------------------";
  fi
  
  