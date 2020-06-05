#!/Users/jkinney/stdpy/bin/python

import os, sys

files = sys.argv[1:]

for f in files:
	base = f.split('.')[0]
	command1 = '/usr/texbin/epstopdf %s.eps'%base
	print 'Processing ' + base + '...'
	os.system(command1)
	
print 'Done!'
