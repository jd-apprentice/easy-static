environment ?= dev
app_name ?= Boilerplate
bucket_name ?= dyallab
access_key ?= $(shell aws configure get aws_access_key_id)
secret_key ?= $(shell aws configure get aws_secret_access_key)