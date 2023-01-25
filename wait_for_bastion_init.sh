	 #!/bin/bash   
	 while ! systemctl status ansible;
      do echo "Ansbile is not running. Sleep for 5 seconds"
	       sleep 5
	    done
