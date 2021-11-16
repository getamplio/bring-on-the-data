# bring-on-the-data

## Setup

### Docker

Make sure that you have Docker [installed](https://docs.docker.com/get-docker/)

Docker Compose willbe install when you install docker from above link.

### Docker Setup

Run the following to make your airflow uid variable:

```sh
echo -e "AIRFLOW_UID=$(id -u)" > .env
```

Run the following to init the db and create a user:

```sh
docker-compose up airflow-init
```

The account created has the login `airflow` and the password `airflow`.

To run Airflow, you can run the following:

```sh
docker-compose up
```

Visit this [url](http://localhost:8080) to go to the Airflow UI.
