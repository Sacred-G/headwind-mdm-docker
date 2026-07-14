# Jfc Technologies MDM (Docker Setup)

Docker build and deployment configuration for **Jfc Technologies MDM** (originally Headwind MDM) — a Mobile Device Management platform for Android devices designed for corporate app developers and IT managers.

This setup is updated to use a modern `tomcat:8.5-jdk8` base image (Ubuntu 22.04 LTS) to resolve legacy repository errors, features automatic branding customizations to **Jfc Technologies MDM**, and supports local building out-of-the-box.

---

## Quick Start

To build the image and start the container locally in the background:

```bash
docker-compose up -d --build
```

The server will be accessible at: **[http://localhost:8080/hmdm/](http://localhost:8080/hmdm/)**
* **Default Login**: `admin`
* **Default Password**: `admin`

---

## How to Build and Push to Docker Hub

If you want to build this MDM container and host it on your own Docker Hub repository, follow these steps:

### 1. Build and Tag the Image
Build the image locally and tag it with your Docker Hub username/repository name:

```bash
docker build -t <your-dockerhub-username>/jfc-hmdm:latest .
```

### 2. Log in to Docker Hub
Authenticate with your Docker Hub credentials:

```bash
docker login
```

### 3. Push the Image
Push the image to your repository:

```bash
docker push <your-dockerhub-username>/jfc-hmdm:latest
```

### 4. Update Docker Compose configuration
Once pushed, update the `image` field in `docker-compose.yml` to point to your new image:

```yaml
version: '3.7'

services:
    mdm:
        image: <your-dockerhub-username>/jfc-hmdm:latest
        ports:
            - 8080:8080
```

---

## Configuration & Environment Variables

The container runs Tomcat 8.5 and PostgreSQL 14. During the first container startup, it auto-configures the database, updates the UI branding, and configures the following environment variables:

- **`HMDM_SQL_HOST`**: PostgreSQL database host (Default: `localhost`)
- **`HMDM_SQL_PORT`**: PostgreSQL port (Default: `5432`)
- **`HMDM_SQL_BASE`**: PostgreSQL database name (Default: `hmdm`)
- **`HMDM_SQL_USER`**: PostgreSQL user (Default: `hmdm`)
- **`HMDM_SQL_PASS`**: PostgreSQL password
- **`HMDM_LANGUAGE`**: Default interface language (Default: `en`)
- **`HMDM_TOMTCAT_PORTOCOL`**: Tomcat HTTP Protocol (`http` or `https`) (Default: `http`)
- **`HMDM_LOCATION`**: Base directory on server to store uploaded app files (Default: `/opt/hmdm`)
