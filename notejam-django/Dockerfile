FROM python:2.7-stretch

LABEL authors="Hossein Salahi"

#Environment variables
ENV PYTHONUNBUFFERED 1
ENV APP_HOME /usr/src/app       

COPY notejam-django/django/notejam /usr/src/app


WORKDIR $APP_HOME

COPY /django/requirements.txt ./
RUN pip install -r requirements.txt
RUN pip install psycopg2

EXPOSE 8000
