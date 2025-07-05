# recipe-app-api
Recipe Api Project
docker build .
# run the docker compose settups
docker-compose build 

docker-compose run --rm app sh -c "flake8"

# creating django from docker compose 
docker-compose run --rm app sh -c "django-admin startproject app ." 

# Run the docker to start the django 
docker-compose up