FROM python
WORKDIR /app
COPY . /app
CMD ["python", "hello.py"]