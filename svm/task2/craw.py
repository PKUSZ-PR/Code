import os
import urllib
import urllib2
import threading 


MAXN = 1 << 11
threads = []


def cb(a, b,c ):
	p = 100.0*a*b/c
	if p>100:
		p = 100
	print '%.2f%%' %p

def craw_pics(url, addr, n):
	rs = 1
	addr = os.path.join(addr, str(n) + ".jpg");
	try:
		urllib.urlretrieve(url, addr, cb)  
		
	except: 
		print 'url error'
		if os.path.exists(addr):
			os.remove(addr)
		rs = 0
	return rs
	
	
	
def start_running(addr, fname):
	fp = open(addr + '\\' + fname,'r');
	fps = open(addr + '\\' + fname + '.rt', 'w+')
	addr_n = os.path.join(addr, fname.split('.')[0])
	if os.path.exists(addr_n):
		pass
	else:
		os.mkdir(addr_n) 
	n = 1;
	data = [[0 for j in range(7)] for i in range(MAXN)]
	for l in fp:
		l = l.split(' ')
		url = l[1]
		print url
		rs = craw_pics(url, addr_n, n)
		if rs == 1:
			
			for j in range(2,9):
				data[n][j - 2] = l[j]
			for i in data[n][:-1]:
				fps.write(str(i) + "#")
			fps.write(str(data[n][-1]))
			n=n+1
		else:
			print 'fucking error url...'
	close(fp)
	
	#for i in range(len(data)):
	#	fp.writelines(data[i,:] + '\n')
	fclose(fps)
	fclose(fp)
	
if __name__ == "__main__":
	addr = 'C:\\Users\\EP\\Desktop\\vgg_face_dataset\\files'
	'''fname = 'Taylor_Swift.txt'''
	name_list = ['Taylor_Swift.txt', 'Adam_Levine.txt']
	fpl = []
	for i in range(len(name_list)):
		fp = open(addr + '\\' + name_list[i] + '.rt', 'w')
	for i in fpl:
		close(i)
		
	for i in range(len(name_list)):
		t = threading.Thread(target = start_running, args=(addr, name_list[i]))
		threads.append(t)
	for t in threads:
		#t.setDaemon(True)
		t.start()
	for t in threads:
		t.join()
	print 'All done'
	#start_running(addr, fname)
	
	
	