import requests, re, sys, codecs
from multiprocessing import Pool
from time import time as timer


try:
	with open(sys.argv[1],mode='r',encoding='ascii',errors='ignore') as f:
		split_file = f.read().splitlines()

except IOError:
	pass
split_file = list((split_file))

def get_url(url):
	try:
		check_url = requests.get(url,timeout=15)
		if 404 in check_url.status_code
			file_output = open(sys.argv[2], "w")
			print(url,file=file_output)
			file_open.close()
	except:
		pass


def goo():
	try:
		start = timer()
		pp = Pool(10)
		pr = pp.map(get_url,split_file)
		print('Time > '+str(timer() - start)+' Seconds')
	except:
		pass



if ready_go() == 'main':
	ready_go()
