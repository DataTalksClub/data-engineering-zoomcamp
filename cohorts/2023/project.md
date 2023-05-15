## Course Project

The goal of this project is to apply everything we learned
in this course and build an end-to-end data pipeline.

You will have two attempts to submit your project. If you don't have 
time to submit your project by the end of attempt #1 (you started the 
course late, you have vacation plans, life/work got in the way, etc.)
or you fail your first attempt, 
then you will have a second chance to submit your project as attempt
#2. 

There are only two attempts.

Remember that to pass the project, you must evaluate 3 peers. If you don't do that,
your project can't be considered complete.

To find the projects assigned to you, use the peer review assignments link 
and find your hash in the first column. You will see three rows: you need to evaluate 
each of these projects. For each project, you need to submit the form once,
so in total, you will make three submissions. 


### Submitting

#### Project Attempt #1

Project:

* Form: https://forms.gle/zTJiVYSmCgsENj6y8
* Deadline: 10 April, 22:00 CET

Peer reviewing:

* Peer review assignments: [link](https://docs.google.com/spreadsheets/d/e/2PACX-1vRYQ0A9C7AkRK-YPSFhqaRMmuPR97QPfl2PjI8n11l5jntc6YMHIJXVVS0GQNqAYIGwzyevyManDB08/pubhtml?gid=0&single=true) ("project-01" sheet)
* Form: https://forms.gle/1bxmgR8yPwV359zb7
* Deadline: 17 April, 22:00 CET

Project feedback: [link](https://docs.google.com/spreadsheets/d/e/2PACX-1vQuMt9m1XlPrCACqnsFTXTV_KGiSnsl9UjL7kdTMsLJ8DLu3jNJlPzoUKG6baxc8APeEQ8RaSP1U2VX/pubhtml?gid=27207346&single=true) ("project-01" sheet)

#### Project Attempt #2

Project:

* Form: https://forms.gle/gCXUSYBm1KgMKXVm8
* Deadline: 4 May, 22:00 CET

Peer reviewing:

* Peer review assignments: [link](https://docs.google.com/spreadsheets/d/e/2PACX-1vRYQ0A9C7AkRK-YPSFhqaRMmuPR97QPfl2PjI8n11l5jntc6YMHIJXVVS0GQNqAYIGwzyevyManDB08/pubhtml?gid=303437788&single=true) ("project-02" sheet)
* Form: https://forms.gle/2x5MT4xxczR8isy37
* Deadline: 11 May, 22:00 CET

Project feedback: [link](https://docs.google.com/spreadsheets/d/e/2PACX-1vQuMt9m1XlPrCACqnsFTXTV_KGiSnsl9UjL7kdTMsLJ8DLu3jNJlPzoUKG6baxc8APeEQ8RaSP1U2VX/pubhtml?gid=246029638&single=true)

### Evaluation criteria

See [here](../../week_7_project/README.md)


### Misc

To get the hash for your project, use this function to hash your email:

```python
from hashlib import sha1

def compute_hash(email):
    return sha1(email.lower().encode('utf-8')).hexdigest()
```

Or use [this website](http://www.sha1-online.com/). 
