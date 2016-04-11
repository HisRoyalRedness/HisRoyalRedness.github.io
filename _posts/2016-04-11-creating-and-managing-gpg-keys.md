---
layout:     post
title:      Creating and managing GPG keys
date:       2016-04-11 18:52 +1300
summary:    Creating and managing GPG keys
categories: gpg
thumbnail:  cogs
tags:       gpg security
---

# Create a new root key

Run ```gpg --gen-key``` to create the key. Prefer option 1 (RSA and RSA), and a large key size (4096).
As this is the root key, it's probably desirable to not have it it expire. Be sure to caredully select
the email address that is associated with the key, as this will be used to identify the key in all 
subsequent steps. Make sure to provide a suitably secure password.

A picture can be added by entering edit mode, namely ```gpg --edit-key me@mail.com```. Then, at the prompt,
enter ```addphoto```, and give the relative to a suitable image file (preferably ```.jpg```). Then type in
```save``` to presist the edits you made, and terminate edit mode.

You can strengthen hash preferences by entering edit mode (```gpg --edit-key me@mail.com```) and entering the
command ```setpref SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed```. Remember
to ```save```.

# Adding a new signing subkey

Get into edit mode by entering ```gpg --edit-key me@mail.com```. Type in the command ```addkey```, and possibly 
the root key's password. Then set the attributes of the new key. Option 4 (RSA sign only) is probably the
most appropriate. Pick a suitable key size and key validity period, then ```save```.

# Exporting the public key

```gpg --output <filename>.pgp --export me@mail.com```. Add ```--armor--``` to the command line if you want a 
text-based file.

# Exporting the subkey

Run this command: ```gpg --output <filename>.pgp --export-secret-subkeys <subkey-id>!```. Take careful note of the exclamation
mark. If you omit this, GPG will resolve the subkey to the associated primary key and export the primary key. We 
don't want this! You can now import the subkey with ```gpg --import <filename>```.

When you import the subkey on another system, it's going to use the same password as the primary key. Ideally you'd like 
to limit the use of the primary key password, but unfortunately is requires a bit of effort to get this right. You'll need
to import your subkey under another user profile, get into edit mode, and then enter ```passwd```. You'll be prompted for 
the primary key password, but are then given the option to set a new password. Remember to ```save```. You can then export
the subkey again, and this time it will have it's own unique password.

# Create a revocation certificate

If you key is lost or compromised, you'll require a revocation certificate to invalidate it. You can create
such a certificate as follows: ```gpg --output <filename>.pgp --gen-revoke me@mail.com```. Naturally you should
guard this file very carefully. 

# Links

* [Creating the perfect GPG keypair](https://alexcabal.com/creating-the-perfect-gpg-keypair/)
* [The GNU Privacy Handbook](https://www.gnupg.org/gph/en/manual.html)