FROM python:3.9-alpine3.13
LABEL maintainer="Tesfaye" 

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
# Copy the requirements-dev.txt file to the temporary directory
# This file is used to install development dependencies
# It is not used in production, but it is useful for development and testing
COPY ./requirements-dev.txt /tmp/requirements-dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Set the environment variable to indicate whether the application is running in development mode or not
# This variable is used to determine whether to install development dependencies or not
# Default is false, meaning the application is running in production mode
ARG DEV=false1

# single run command to install dependencies and create a virtual environment
# and create a non-root user    
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # If the application is running in development mode, install the development dependencies
    # This is useful for development and testing, but not for production
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements-dev.txt; \
    fi && \
    rm -rf /tmp && \
    # Create a non-root user to run the application to avoid running as root if the application is compromised the attacker will not have root access
    # and to avoid permission issues with the application files
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
# Creaete temp vetual environment to store dependencies and resolve conflicting dependencies with the base image upon which the application is running
ENV PATH="/py/bin:$PATH"
# Set the user to the non-root user created above   
USER django-user

