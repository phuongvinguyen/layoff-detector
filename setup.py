# setup.py

from setuptools import setup, find_packages

setup(
    name="layoff",
    version="0.1",
    packages=find_packages(),
    install_requires=[
        "yfinance",
        "pandas",
        "numpy",
        "tabula-py",
    ],
    packages=find_packages(
        where=".",
        include=["layoff*"],
        exclude=["data*", "tests*", "scripts*", "notebooks*", "src*"]
    ),
)