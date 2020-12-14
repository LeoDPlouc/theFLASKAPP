FROM python:latest

WORKDIR /FlaskApp

ENV SECRET_KEY="not_so_secret"
ENV POSTGRES_PASSWORD="not_default_password"
ENV POSTGRES_USER="base_user"
ENV POSTGRES_DB="database"
ENV USE_POSTGRES=1

COPY templates templates
COPY tests tests
COPY app.py app.py
COPY config.py config.py
COPY data.sqlite data.sqlite
COPY model_saved model_saved
COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -P /scripts
RUN chmod +x /scripts/wait-for-it.sh
ENTRYPOINT ["/scripts/wait-for-it.sh", "db:5432", "--"]

CMD python app.py runserver --host=0.0.0.0 --threaded