import time; 
import sys; 
import os; 

def printf(format, *args):
    print(format % args)



if len(sys.argv) < 2:
   print "please specify a filename to process...."
   sys.exit(1)

filename = sys.argv[1]

if not os.path.isfile(filename):
   print "file does not exists or is not readable!"
   sys.exit(1)

outfile = filename + ".hr.csv"
print "in: %s    ->   out: %s" % (filename, outfile)

c = 0
try:
    with open(filename) as f:
        out = open(outfile, "w")
    
        headers = f.readline()
        out.write(headers)
        for line in f:
           c = c + 1
           s = line.split(",")
           ts = s[0]
           epoch = int(ts[0:-3])
           ms = ts[-3:]
           humane = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(epoch))

           # printf("%s.%s (%s),%s", humane, ms, ts, ",".join(s[1:]))

           out.write("%s.%s (%s),%s" %( humane, ms, ts, ",".join(s[1:])))

except IOError:
    print("File not accessible")
finally:
    out.close()
    f.close()
