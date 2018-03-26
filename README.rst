1. What do the following commands do and how would you use them?
================================================================

tee
---

tee redirects its input to both, a file and stdout.

Example:

.. code-block::

  $ sudo tcpdump -vvv | tee -a /tmp/dump1.txt

awk
---

processes the input.Example:

.. code-block::

    $ ps aux | grep firefox | grep -v grep | awk '{print $2}' | xargs kill

tr
---

I don't use this command often, but I can think it is useful to change separators in a file:

.. code-block::

    $ echo "1.2.3.4;duck" | tr \; \ 
    1.2.3.4 duck

cut
---

I rarely use this command:

If a line in access.log is like `127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326`

Then with `cut` I can get the different fields.

.. code-block::

	$ cat /var/log/nginx/access.log | cut -d \  -f 6,7
	GET /apache_pb.gif
	$ cat /var/log/nginx/access.log | cut -d \  -f 9 | uniq -c
		50 200
		10 301
		20 404

tac
---

I didn't know `tac`. I use `head` instead of `tac`


curl
----

I use curl to perform HTTP(S) to REST APIs. To test those APIs, usually.

If I set up a new service or I want to test if a service is working, I use curl:

.. code-block::

	$ curl -vvv -X POST 'https://httpbin.org/post'

wget
----

I use wget to download stuff from the web. It can recursively fetch web ressources.

.. code-block::

	$ wget 'https://docs.python.org/3/download.html'

watch
-----

Watch runs a command periodically. It is useful to check for changes in a log file, e.g.

.. code-block::


	$ sudo watch -n 4 tail /var/log/auth.log

head
----

Shows the beginning of the file. Default is the first 10 lines. It is useful to take a
quick look to a logfile or to combine it with some script.

tail
----

Shows the bottom of a file. Default is the last 10 lines. It is useful to take a
quick look to a logfile or to combine it with some script.

.. code-block::

	sudo tail -n 50 /var/log/syslog


2 Bash
======

Explain the following command:

.. code-block::

	(date ; ps ­-ef | awk '{print $1}' | sort | uniq | wc ­-l ) >> Activity.log

It writes the number of users who have running processes/thread, together with a timestamp, in the Activity.log.

	* `date` is just printing a timestamp to stdout.
	* `ps -ef` shows all processes with full format,
	* `awk` is taking the first column (the user of the process)
	* `| sort | uniq |` can be written `| sort -u |`, it is sorting alphabetically the users and removing duplicates
	* wc -l is just count the lines, so, the number of users.


3 How does HTTP work? How does a web page appear in a browser?
==============================================================

HTTP is a plain text protocol with two roles: the client and the server. It works through TCP.

The client asks the server for resources with different verbs.
The operation performed on the resources depends on the verb. Typical verbs are GET to get a copy of the resource; DELETE to remove it, if it is possible; POST, PUT, HEAD, OPTIONS are other verbs.

For example, a client will initiate a TCP connection against a web server and ask for the main page:

.. code-block::

	GET /index.html HTTP/1.1
	User-Agent: Safari x.y MacOS z.k
	Cookie: session=1234beef

When the server receives this, it knows it has to do a GET (i.e. fetch the file), over /index.html.
The client speaks version 1.1 of the HTTP protocol.
Afterwards there are some headers, to share cookies, accepted encodings or other information between client and server.

The server answers with something like:

.. code-block::

	HTTP/1.1 200 OK
	Server: nginx
	Content-Type: text/html
	Connection: keep-alive

	<html>
	<title>web site</title>
	<script src="//cdn.cloudflare.com/tatata/foo.js"></script>
	</html>

`200 OK` means, everything went fine with the request.

Some headers are provided:

	* `Content-Type: text/html` to indicate format of the answer (HTML page),
	* `Connection: keep-alive` to keep the same connection for future requests, etc.

And finally the content of the resource, in this case an HTML page.

The browser would analyse the HTML page, discover if it has to load external resources
(like images, CSS or Javascript), fetch those resources and then draw the page on
the window, as soon as it has the required resources to start rendering it.

The internal working of a web browser are really complicated and nowadays browsers are
a very obfuscated piece of engineering. They are also optimised to keep the number
of connection the lowest and load several resources at the same time.

4 Describe briefly how HTTPS works
===================================

HTTPS is the *safe* version of HTTP, where safe means, it is harder for someone
to read or tinker with the communication between client and server. It usually
provides some additional privacy when it is properly configured in the server
and properly used in the client and in the websites.

It works by encapsulating HTTP protocol over a SSL/TLS tunnel. TLS is another binary
protocol, that runs over TCP (DTLS is an alternative for UDP). Its purpose is to
secure the communication, by encrypting it and authentifying both peers in a way
that prevents a 3rd party to read the communication and detects if there is any
manipulation.
TLS begins with a handshake where client and server get to know each other, authenticate
themselves via certificates and get to know which parameter they provide (ciphersuites,
encryption modes). They choose the safest common algorithm and mode available, they
create and share some encryption keys, and they will tunnel another protocol ciphering
the date with those keys. Usually HTTP, SMTP and IMAP are tunneled through TLS.
A weak point of TLS is its reliance on the Cartificate system: someone should prove
the parts are properly certified and the certificate is up to date. Another weak point
is the configuration of the TLS server: there are plenty of moving parts (HSTS, OCSP,
Forward Secrecy, SNI) and tuning them properly requires a good understanding.

5 What is a certificate and how does it work?
=============================================

A certificate is a way to prove a site is actually who it claims to be. It relies
on a Certificate Authority (CA). The CA proves the website belongs to an specific 
entity (person, enterprise, institution) and issues the certificate, who will be
used later on to sign via TLS all the information provided by the website.

The client receiving this information must check if the certificate provided by
the website is authentic, not expired and not revoked. This step requires trusting
the CA and knwoing its certificate (in addition to the website's certificate).

There are CAs which certify other CAs, building a hierarchy. For testing purposes
one can be its own CA and sign its own certificates.

The CAs are also responsible of keeping a list of invalid certificates.

A way to bypass CAs is using DNSSEC plus DANE.

6. Difference between UDP and TCP
=================================

Both are transport layer protocols, designed to transfer data between two devices
(client and server model), instead of signaling errors or other network information
(like ICMP or BGP, e.g.).

TCP is more complicated than UDP. It establishes a connection between client and server,
which means, there is a 3-way handshake at the beginning and there is a procedure to
finish a connection.

TCP has a mechanism to ensure all data arrives at the other end, by waiting an acknowledge
from the other end, or resending the data if no acknowledge comes, or finishing the
connection if the other end seems unresponsive.

The handshake and the transmission control introduce slow-down in the communication.

UDP is much simpler, there is no guarantee about data arriving to the other end. Nowadays
this can be guaranteed by other protocols in layers below. UDP lacks the overhead
of establishing a connection and finishing it and doesn't need to wait for the
acknowledge of the data.

Devices in UDP are easy to impersonate.

QUIC tries to be a way to have the advantages of TCP with the advantages of UDP, but
it is not widely implemented.

7. What is DNS and which port number is used by DNS? How does it work?
======================================================================

DNS is a distributed hierarchical system to translate domain names into IP addresses.

A device must know at least a DNS server, which runs DNS service on port 53, usually
in UDP, although could be in TCP as well.

The device will ask the DNS server about e.g. the A record for e.g. httpbin.org. If present,
the DNS server will answer at least with an Answer section associating an IP address with
that name. Optionally, it could include more sections. If not present, the DNS server may
forward the query to a 2nd DNS server, or just assume that there is no information.
If the DNS server already fetched an answer for that query, it may cache the result and
return an Non-Authoritative answer. The cache will eventually expire.

To serve a given domain, the DNS server must be configured with some zones, which
are the domain(s) served.

DNS has different kind of records: A for IPv4 addresses, AAAA for IPv6, CNAME for
aliases, MX for mail exchanges, SPF and TXT used to configure email and spam filtering,
SSHFP to store the fingerprint of an ssh server, SOA, AXFR, etc.
DNS has extensions: DNSSEC and DDNS.

A DNS server receives information about the websites someone visits, therefore it
may leak information about Internet usage (aka DNS Leaks, http://dnsleaktest.com/).

.. code-block::

	$ dig -t DNSKEY ietf.org

	;; ANSWER SECTION:
	ietf.org.               1665    IN      DNSKEY  256 3 5 AwEAAdDECajHaTjfSo[...]=

8. CSV file
===========

.. code-block::

	$ cat sample.input | tr '\n' ';'
	Albany, N.Y.;Albuquerque, N.M.;Anchorage, Alaska;Asheville, N.C.;Atlanta, Ga.;Atlantic City, N.J.;Austin, Texas;Baltimore, Md.;Baton Rouge, La.;Billings, Mont.;Birmingham, Ala.;Bismarck, N.D.;Boise, Idaho;Boston, Mass.;Bridgeport, Conn.;

but that gives an extra ; at the end. To avoid that ; I could do some python.

9. Last and Second Last
=======================

.. code-block:: python

	#!/usr/bin/python3

	import sys


	def last_and_second_last(inp):
    	if len(inp) == 0:
	        out = ""
	    else:
        	out = inp[-1]
	        out += " " + inp[-2] if len(inp) > 1 else ""
    	return out


	inp = input("Type a word: ")
	if len(inp) < 1 or len(inp) > 100:
	    print("Word length should be between 1 and 100", file=sys.stderr)
	    sys.exit(1)
	out = last_and_second_last(inp)
	print(out)


10. What steps would you take to harden a Linux server that was just created?
=============================================================================

	* Check running services and open ports.
		* Remove not needed services and software.
		* Configure services properly, if they have to be running
			* on which interface should they listen?
			* do they need authentication. Avoid default passwords.
		* Configure firewals: iptable or Amazon Security Groups.
	* Verify users.
		* Which users do I need?
		* All of them need an enabled account?
		* All of them need shell?
		* Who need sudo?
		* Are they changing passwords often?
		* Are they using strong enough passwords?
	* Keep logs
		* Make sure I am logging all that I need.
		* Export logs outside the machine in real time.
		* Rotate logs to avoid a full disk
	* rootkithunter and similar software.
		* Maybe also to detect port scans.

13. What’s the difference between forward proxy and reverse proxy?
==================================================================

The forward proxy is used to cache web content, anonymise traffic or censor requests.
Reverse proxy is used to balance traffic between different servers.

A proxy is always hiding a group of computers. It can hide them before their traffic
reaches internet (forward), or before the internet traffic reaches them (reverse).


14. What does IPSec do when you connect to an L2TP/IPSec VPN server?
====================================================================

Can L2TP work without IPSec? Why?

L2TP works without IPSec, it just has much less security. IPSec tunnels L2TP or other
protocols encrypting the data and authenticating the peers.


15. Which VPN protocol do you like best? Why?
=============================================

	* OpenVPN, because it is the most standard to secure the connections between two devices.
	* IPsec could be a good solution to interconnect securely two networks, but I think I read not every router allows IPsec traffic.
	* I read Tinc is easier to setup than OpenVPN, but I have never used it.

16. What are the benefits of using freeradius?
==============================================

FreeRADIUS in an open source implementation of RADIUS. I usually like open source,
it enables anyone to set it up and to grow the project. I think
in the long run it is safer than proprietary implementations.

I have no experience with RADIUS. I have the idea it is used to authenticate
users in wifi networks. Probably also it is possible to authenticate people
in VPNs.

