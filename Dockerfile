FROM python:3.8 as builder

ARG APP_USER=deployer
RUN groupadd -r ${APP_USER} && useradd --no-log-init -r -g ${APP_USER} ${APP_USER}

COPY requirements.txt .
RUN pip install --user -r requirements.txt

FROM python:3.8-slim
WORKDIR /code

COPY --from=builder /root/.local /root/.local
COPY ./ .


ENV PATH=/root/.local:$PATH

EXPOSE 5000

USER ${APP_USER}:${APP_USER}

# command to run on container start
CMD [ "python", "./app.py" ]