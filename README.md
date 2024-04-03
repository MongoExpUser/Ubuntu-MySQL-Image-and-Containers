
# Ubuntu-MySQL-Image-and-Containers
## MySQL Primary-Primary-Replica Setup

<strong> Create Image and Deploy Containers of MySQL Servers (2 Primary and 1 Replica) for a Listing and Searching Application (LSA) .</strong>
<br>

### Architectural Diagram Depicting MySQL Primary-Primary and Replica Setup.
![Image description](https://github.com/MongoExpUser/Ubuntu-MySQL-Image-and-Containers/blob/main/mysql-arch.png)

     *  Both primary (source) nodes can be used for write and read operations.                                      
     *  If the main primary (source-1/primary-1) node goes down, the 2nd primary can continue to serve as a primary.                     

### 1) Build Image:                                                                                             
     * Build
     sudo docker build --no-cache -t lsa/ubuntu-22.04-mysql-8.3.0:latest .

### 2) Edit the config settings in the docker compose file in the repository, as deem necessary:    
       Docker compose file name: docker-compose-mysql.yml

### 3) Deploy Containers and Destroy with Docker Compose:                                                                                             
     * Deploy containers 
     set PWD=%cd% && sudo docker compose -f docker-compose-mysql-g.yml --project-directory $PWD --project-name "lsa-app" up -d
     * Stop and remove containers with related network and volumes
     set PWD=%cd% && sudo docker compose -f docker-compose-mysql-g.yml --project-directory $PWD --project-name "lsa-app" down && sudo docker volume rm $(docker volume ls -q)

### 4) Stop, Re-Start and Log Services with Docker Compose: 
     * Stop services
     set PWD=%cd% && sudo docker compose -f docker-compose-mysql-g.yml --project-directory $PWD --project-name "lsa-app" stop
     * Start services
     set PWD=%cd% && sudo docker compose -f docker-compose-mysql-g.yml --project-directory $PWD --project-name "lsa-app" start
     * Log: view output from containers
     set PWD=%cd% && sudo docker compose -f docker-compose-mysql-g.yml --project-directory $PWD --project-name "lsa-app" logs 

### 5) Stop, Re-Start, and Check Status of, MySQL Services on the Nodes: 
     * Primary-Node-1 
     sudo docker exec -it primary-node-1 /bin/bash -c "sudo service mysql stop"
     sudo docker exec -it primary-node-1 /bin/bash -c "sudo service mysql status"
     sudo docker exec -it primary-node-1 /bin/bash -c "sudo service mysql start"
     * Primary-Node-2 
     sudo docker exec -it primary-node-2 /bin/bash -c "sudo service mysql stop"
     sudo docker exec -it primary-node-2 /bin/bash -c "sudo service mysql status"
     sudo docker exec -it primary-node-2 /bin/bash -c "sudo service mysql start"
     * Replica-Node-3 
     sudo docker exec -it replica-node-3 /bin/bash -c "sudo service mysql stop"
     sudo docker exec -it replica-node-3 /bin/bash -c "sudo service mysql status"
     sudo docker exec -it replica-node-3 /bin/bash -c "sudo service mysql start"

### 6) Log and Inspect Containers:
     * Log
     sudo docker logs primary-node-1
     sudo docker logs primary-node-2
     sudo docker logs replica-node-3
     * Inspect
     sudo docker inspect primary-node-1
     sudo docker inspect primary-node-2
     sudo docker inspect replica-node-3

### 7) Connect to Containers (Interact with Containers) From the Docker Host:                                                                                        
     sudo docker exec -it primary-node-1 /bin/bash
     sudo docker exec -it primary-node-2 /bin/bash
     sudo docker exec -it replica-node-3 /bin/bash
     
### 8) Connect to MySQLSQL Servers From the Docker Host: Run Directly with Bash:                                                                                          
     sudo docker exec -it primary-node-1 /bin/bash -c "mysql";
     sudo docker exec -it primary-node-2 /bin/bash -c "mysql";
     sudo docker exec -it replica-node-3 /bin/bash -c "mysql";

### 9) Check Replication Status After Deployment: Run Directly with Bash: 
     sudo docker exec -it primary-node-1 /bin/bash -c "mysql --execute 'SHOW MASTER STATUS\G; SHOW REPLICA STATUS\G; SHOW SLAVE HOSTS;'"
     sudo docker exec -it primary-node-2 /bin/bash -c "mysql --execute 'SHOW MASTER STATUS\G; SHOW REPLICA STATUS\G; SHOW SLAVE HOSTS;'"
     sudo docker exec -it replica-node-3 /bin/bash -c "mysql --execute 'SHOW MASTER STATUS\G; SHOW REPLICA STATUS\G; SHOW SLAVE HOSTS;'"

### 10) Check Configuration Information: Run Directly with Bash:                                                                                                                    
    * Configuration Settings in my.conf and other default values
     sudo docker exec -it primary-node-1 /bin/bash -c "sudo mysql --execute 'SHOW VARIABLES\G;'"
     sudo docker exec -it primary-node-2 /bin/bash -c "sudo mysql --execute 'SHOW VARIABLES\G;'"
     sudo docker exec -it replica-node-3 /bin/bash -c "sudo mysql --execute 'SHOW VARIABLES\G;'"


# License

Copyright © 2024. MongoExpUser

Licensed under the MIT license.
