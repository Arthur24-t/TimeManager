# Time Manager - DevOps

## Overview

The Time Manager project is a web application that helps users manage their time efficiently. It consists of three main services:
1. **Frontend**: The application's user interface.
2. **API**: The backend that processes requests and interacts with the database.
3. **Database**: Stores all the data required by the application.

Each of these services is containerized using Docker and orchestrated with Docker Compose for easy deployment and management.

## Table of Content

- [Prerequisite](#prerequisite)
- [Installation and Start-up](#installation-and-start-up)
- [Access to Services](#access-to-services)
- [Support and Contribution](#support-and-contribution)
- [Hosting and Access to the Application](#hosting-and-access-to-the-application)

## Prerequisite

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

Make sure you have **Docker** and **Docker** Compose installed on your machine before continuing.

## Installation and Start-up

1. Clone the project's Git repository on your local machine:
   ```
   git clone https://your-git-repository-url.git
   cd your-project-directory
   ```

2. Start all services with Docker Compose :
   ```
   docker-compose up
   ```

This command:
1. **Reads** the `docker-compose.yml` file in the directory
2. **Creates** Docker images if necessary
3. **Starts** the containers.

## Access to Services

Once the services have been started, you can access them at the following addresses:

- **Frontend**: [http://localhost:8080](http://localhost:8080)
- **API**: [http://localhost:4000](http://localhost:4000)
- **Database**: Port 5432 (only accessible from other Docker services)

## Support and Contribution

For any questions, bugs or suggestions, please create an issue in the project's Git repository.

## Hosting and Access to the Application

The application is hosted on a Raspberry Pi server on our premises. The ports required to access the services have been opened on our Internet box to enable remote access.

You can access the application in production at the following address: 
- [http://timemanager.freeboxos.fr](http://timemanager.freeboxos.fr:8080)