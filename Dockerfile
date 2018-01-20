FROM python:3.6
MAINTAINER Borodin Gregory <grihabor@mail.ru>

RUN apt update

RUN pip3 install --no-cache-dir \
        numpy \
        scikit-image

WORKDIR /project

ADD . .
RUN pip3 install .

CMD ["python3", "run.py"]
