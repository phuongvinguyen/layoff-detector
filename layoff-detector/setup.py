# setup.py

from setuptools import setup, find_packages

setup(
    name="layoff-detector",
    version="0.1",
    packages=find_packages(),
    install_requires=[
        "yfinance",
        "pandas",
        "numpy",
        "tabula-py",
    ],
)