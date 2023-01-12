FROM ubuntu:latest

WORKDIR /app

USER root
RUN apt install python3-pip

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 80

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
