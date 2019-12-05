# Using python2.7
FROM python:2.7-slim

MAINTAINER Ramakrishna Kothamasu "krishna.ubuntu@gmail.com"

WORKDIR /app

COPY . /app

# Install Flask and ipaddress
RUN pip install --trusted-host pypi.python.org -r requirements.txt

ENTRYPOINT [ "python" ]

ENV db_service_ip 10.60.9.125

# EXPOSE 5000

# Run app.py when container launaches
CMD [ "app.py" ]
