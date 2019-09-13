hello ford security team
i found openredirect and html injection in this subdomain https://www.etis.ford.com

POC URL html injection:-
https://www.etis.ford.com/externalURL.do?url=%3C!--Hello%20team%20i%27m%20here%20[xElkomy]--!%3E%3Cdiv%3E%3Ch1%3ExElkomy%20Here%3C/h1%3E%3C/div%3E

POC URL Open Redirect:-
Here is a proof of concept to
demonstrate how an open redirect occurs. Please note that this 
particular example is not a vulnerability and just here for demonstration purposes.
URL=https://www.etis.ford.com/externalURL.do?url=http://evil.com
will be converd to any website when you change the last pramter

impact html injection:-
this vulnerability is dangerous. You can put in the href url of the phishing site, then you can steal the private key of the victim. Perhaps you can upload js to the site, but I could not do it.

impact Open redirect:-
Attackers may be able to use this to execute believable phishing attacks, bypass authentication, or (in rare circumstances) violate CSRF mitigations.













and this again step above:-
http://www.etisorigin2.ford.com/
