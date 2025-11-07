import os
from setuptools import setup, find_packages


def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()


setup(
    name="workstation1",
    version="2.0.0",
    author="Nicholas Etuk",
    author_email="nick_etuk@hotmail.com",
    description=("Workstation setup script"),
    license="",
    keywords="workstation setup",
    url="http://asterlan.com",
    packages=find_packages(","),
    long_description=read("README.md"),
    classifiers=[],
)
