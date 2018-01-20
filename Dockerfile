FROM python:3.6
MAINTAINER Borodin Gregory <grihabor@mail.ru>

RUN apt update

RUN pip3 install --no-cache-dir \
        numpy \
        scikit-image

RUN pip3 install cython

WORKDIR /project

ADD . .
RUN python3 setup.py build_ext --inplace


CMD ["python3", "run.py"]
