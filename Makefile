SHELL := /bin/bash
PWD = $(shell pwd)
PYTHON = $(PWD)/venv/bin/python3
GREP := $(shell command -v ggrep || command -v grep)

help:
	@$(GREP) --only-matching --word-regexp '^[^[:space:].]*:' Makefile | sed 's|:[:space:]*||'

clean: clean-build clean-pyc clean-test

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -fr .tox/

test:
	py.test tests

test-all:
	tox

register: dist
	twine register dist/*.whl

release: dist
	twine upload dist/*

dist: clean docs
	$(PYTHON) setup.py sdist
	$(PYTHON) setup.py bdist_wheel
	ls -l dist

venv:
	$(PYTHON) -m venv venv
	venv/bin/pip install --upgrade pip

.PHONY: clean-pyc clean-build docs clean register release clean-docs help
