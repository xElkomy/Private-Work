hello security team ford i found subdoamin vuln from arabitrary upload malicious files 
this hard impact.

Subdomain Vuln:-
ecco-qa-vip-ashburn_pp.ash.ford.com

POC URl malicious file i'm uploaded this :-
https://ecco-qa-vip-ashburn_pp.ash.ford.com/documents/elkomy.html
or
https://ecco-qa-vip-ashburn_pp.ash.ford.com/documents/xss.svg
or xml files.

POC html form me:-

images:-
1-
2-
3-

video:-

impact:-

This weakness occurs when application does not validate or improperly validates 
files types before uploading files to the system. This weakness is 
language independent but mostly occurs in applications written in ASP and PHP.
