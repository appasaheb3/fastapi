FROM ubuntu:latest

WORKDIR /app

USER root
RUN apt-get add python3 && python3 -m ensurepip && pip3 install --upgrade pip setuptools && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && rm -r /root/.cache

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 80

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
