#!/usr/bin/python

import sys
import socket
import ntpath

PORT = 23


def transceive(socket, ip, data):
    print data
    socket.sendto(data, (ip, PORT))
    print socket.recvfrom(1024**2)[0]


def send_file(ip, filename):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    with open(filename) as f:
        # Strip paths from the filename, if present
        filename = ntpath.basename(filename)

        lines = [line.strip('\n') for line in f.readlines()]

        transceive(s, ip, 'file.remove("%s")' % filename)
        transceive(s, ip, 'file.open("%s", "w+")' % filename)
        transceive(s, ip, 'w = file.writeline')


        for line in lines:
            transceive(s, ip, 'w([[ %s ]])' % line)

        transceive(s, ip, 'file.close("%s")' % filename)

        if filename.endswith('.lua'):
            transceive(s, ip, 'node.compile("%s")' % filename)



if __name__ == '__main__':

    if len(sys.argv) != 3:
        print 'Usage: sendfile.py ip filename'
        print 'Example: sendfile.py 192.168.0.20 init.lua'
        exit(0)

    send_file(sys.argv[1], sys.argv[2])