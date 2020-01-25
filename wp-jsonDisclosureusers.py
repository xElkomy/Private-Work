import requests
import threading
import sys


urls = sys.argv[1]

def request(url):
    try:
        return requests.get(url)
    except requests.exceptions.ConnectionError:
        pass


f = open(urls,'r')
for line in f:
    word = line.strip()
    full_url = word + '/wp-json/wp/v2/users'
    response = request(full_url)
    if response:
        print ('[+] Catch : ' + full_url)

thread = []
t = threading.Thread(target=request())
thread.append(t)
t.start()
