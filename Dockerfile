FROM python:3.7

ADD . /code

WORKDIR /code

ENV ENVIRONMENT=DEV

ENV PORT=8000

ENV REDIS_PORT=6379

ENV REDIS_DB=0

EXPOSE 8000

RUN pip install -r requirements.txt

CMD ["python", "hello.py"]
