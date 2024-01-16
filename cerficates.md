## Getting your certificate

Congratulations on finishing the course!

Here's how you can get your certificate.

First, get your certificate id using the `compute_certificate_id` function:

```python
from hashlib import sha1

def compute_hash(email):
    return sha1(email.encode('utf-8')).hexdigest()

def compute_certificate_id(email):
    email_clean = email.lower().strip()
    return compute_hash(email_clean + '_')
```

> **Note** that this is not the same hash as you have on the leaderboard
> There's an extra "_" added to your email, so the hash is different.


Then use this hash to get the URL

```python
cohort = 2023
course = 'dezoomcamp'
your_id = compute_certificate_id('never.give.up@gmail.com')
url = f"https://certificate.datatalks.club/{course}/{cohort}/{your_id}.pdf"
print(url)
```

Example: https://certificate.datatalks.club/dezoomcamp/2023/fe629854d45c559e9c10b3b8458ea392fdeb68a9.pdf


## Adding to LinkedIn

You can add your certificate to LinkedIn:

* Log in to your LinkedIn account, then go to your profile.
* On the right, in the "Add profile" section dropdown, choose "Background" and then select the drop-down triangle next to "Licenses & Certifications".
* In "Name", enter "Data Engineering Zoomcamp".
* In "Issuing Organization", enter "DataTalksClub".
* (Optional) In "Issue Date", enter the time when the certificate was created.
* (Optional) Select the checkbox This certification does not expire. 
* Put your certificate ID.
* In "Certification URL", enter the URL for your certificate.

[Adapted from here](https://support.edx.org/hc/en-us/articles/206501938-How-can-I-add-my-certificate-to-my-LinkedIn-profile-)
