# add Git to GCP VM

## 1. Set your global git credentials

```console
git config --global user.name 'User' 
git config --global user.email 'User Email'
```

## 2. Generate a new SSH key for GitHub

```console
ssh-keygen -t rsa -b 4096 -C 'User Email'
```
this generates id_ecdsa.pub and id_ecdsa, use the public file to copy key to github

## 3. Testing connection

```console
ssh -T git@github.com
Hi Maseo! You've successfully authenticated, but GitHub does not provide shell access.
```

clone the relevant repo and happy coding
