from setuptools import setup
import os

_ROOT = os.path.abspath(os.path.join(__file__, os.pardir))


def _get_readme():
    path = os.path.join(_ROOT, 'README.rst')
    with open(path, 'r') as f:
        return f.read()


setup(
    name='fracpy',
    author='Borodin Gregory',
    author_email='grihabor@mail.ru',
    license='MIT',
    requires=[],
    version='0.0.1',
    description='Fractal library',
    long_description=_get_readme(),
)
