# Configration
* notebooks: jupyter notebooks
* src: python source files
* data: data(.gitignore)
* model: modelfile(.gitignore)

# Docker Setup

## components
* Dockerfile
* docker-compose.yml
* requirements.txt


## How to start

make docker image
```
$ docker-compose build
```

run the image

```
$ docker-compose up -d
```

## check the state
```
$ docker-compose ps
```

## how to access to the jupyter notebook
ip_address = localhost , if you use local machine
```
http://<ip_address>:8888/tree?token=t0ken
```

## exit
```
$ docker-compose down
```

## how to get into the container
```
$ docker-compose exec app bash
```

# Tips not to commit the cell outputs of jupyternotebooks
```
pip install --upgrade nbstripout
```
