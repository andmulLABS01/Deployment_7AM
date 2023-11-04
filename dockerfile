FROM python:3.7

RUN git clone https://github.com/andmulLABS01/Deployment_7AM.git

WORKDIR Deployment_7AM

RUN pip install -r requirements.txt

RUN pip install gunicorn

RUN python database.py

RUN python load_data.py

EXPOSE 8000

CMD [ "gunicorn", "--bind", "0.0.0.0", "app:app"] 

