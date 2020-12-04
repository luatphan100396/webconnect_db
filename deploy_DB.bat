 echo "Start deploy DB." > deploy.log;
 Error=0;
 
 IsFreshMode=1;
 DB_Name=`sed -n '/# DB Name/p' DB_name.txt | awk '{print $1}' | tr '[a-z]' '[A-Z]' `;
 echo "DB Name = ${DB_Name}"
  
 for f in $(db2 list db directory | grep Indirect -B 5 |grep "Database name" |awk {'print $4'}   );
 do
 
  if [ "${f}" = "${DB_Name}" ]
  then 
    IsFreshMode=0;
  fi
 done
  
 if [ ${IsFreshMode} -eq 1 ]
  then 
         echo "Deploy fresh mode";
		 db2 create database ${DB_Name} >> deploy.log;
		 db2 connect to ${DB_Name};
		 bash deploy_DM.bat
		 if [ $? -gt 0 ]
		   then 
			  Error=1;
			  break;
		  fi
		   
		 bash deploy_Data.bat
		 if [ $? -gt 0 ]
		   then 
			  Error=1;
			  break;
		  fi
 fi
		bash deploy_DB_Upgrade.bat
		 if [ $? -gt 0 ]
		   then 
			  Error=1;
			  break;
		  fi
		 bash deploy_Data_Upgrade.bat
		 if [ $? -gt 0 ]
		   then 
			  Error=1;
			  break;
		  fi
        
         bash deploy_View_SP_Synonym.bat
		 if [ $? -gt 0 ]
		   then 
			  Error=1;
			  break;
		  fi
		 
		 if [ ${Error} -gt 0 ]  
		  then 
				echo "Deploy DB failed";
				exit;
				 
		  else 
				echo "Deploy DB successfully";
		  fi
  
  
  
