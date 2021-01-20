nohup xray --bind=0.0.0.0:2000 --region=us-east-1 < /dev/null & 
gunicorn -b 0.0.0.0:80 -w 1 --log-level DEBUG -t 800 wsgi:app