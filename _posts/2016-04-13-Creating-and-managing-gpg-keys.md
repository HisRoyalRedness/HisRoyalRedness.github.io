---
layout:     post
title:      Starting up with GnuPG
date:       2016-04-13 21:56 +1300
summary:    blah blah blah
categories: gpg
thumbnail:  cogs
tags:       gpg encryption
---

* TOC
{:toc}

# Starting up with GnuPG

## Planning

Before jumping into the key creation, you should really decide why it is that you want 
a key, what your intended uses for it are and how secure you wish to be. Security and
convenience are on opposite ends of the scale, and you need to determine how much 
effort you're willing to put in for a given level of security and vice versa.

It's best to do the research and make the decisions up front, because once you've started,
and especially once you've published your keys, it could be troublesome to change tack.

* [OpenPGP for beginners][10]
* [OpenPGP: Getting started][11]
* and of course the [The GNU Privacy Guard Manual][12]

The rest of the post is primarily a record of the decisions that I've taken, mostly
for my own benefit, but it could possibly help you get going too. Please be advised
that I make absolutely no guarantee that this is best practise, or even good practise
for that matter. I'm not an expert. Look elsewhere if you want something more 
authoritative (perhaps start with the links above). If you follow this advice and get 
hacked, lose data, your house burns down and your spouse runs off with the neighbour: 
NOT MY PROBLEM!

## Creating the primary key

It's recommened (just about everywhere, I'm not going to bother to reference this) that
you generate and use your primary key as securely as possible. Think along the lines of a
non-networked computer, with the hard-drives removed, booting from a Tails Live CD. It's 
up to you to decide far to go, but this is where you want to be as secure as you can 
possibly be. 

My opinion: a Raspberry Pi with a keyboard, mouse and monitor (no network, ever!) makes
a wonderfully useful, cheap and secure environment for working with your primary key.
You can transfer keys to and from your Pi with a USB stick (or a Pi camera and QR codes 
if you're really serious about it), and once done, store your Raspberry Pi somewhere
safe until you need it to work on your primary key again. 


With that in mind, and hopefully in a secure environment, fire up gpg with expert mode on. 


```gpg --expert --gen-key```

Strongly prefer [RSA<sub>1</sub>][1] as your algorithm of choice. Select option 8 so that
we can remove some fo the capabilities from the primary key.

    gpg (GnuPG) 2.0.30; Copyright (C) 2015 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    
    Please select what kind of key you want:
       (1) RSA and RSA (default)
       (2) DSA and Elgamal
       (3) DSA (sign only)
       (4) RSA (sign only)
       (7) DSA (set your own capabilities)
       (8) RSA (set your own capabilities)
    Your selection? 8

The primary key should Certify [only<sub>2</sub>][2]. Remove the options to Sign and Encrypt. 
We'll create seperate subkeys for signing, encryption and authentication later.

    Possible actions for a RSA key: Sign Certify Encrypt Authenticate
    Current allowed actions: Sign Certify Encrypt
     
       (S) Toggle the sign capability
       (E) Toggle the encrypt capability
       (A) Toggle the authenticate capability
       (Q) Finished

The primary key should have the [largest<sub>1</sub>][1] [key-length<sub>3</sub>][3] possible, currently ```4096```.
We can probably afford to make some of the subkey key-lengths shorter, depending on how they are to be used.


    RSA keys may be between 1024 and 4096 bits long.
    What keysize do you want? (2048) 4096
    Requested keysize is 4096 bits

Set [expiry<sub>4</sub>][4] [date<sub>5</sub>][5] to 1 year. Some articles say it should be longer, some say it
should be the same period as the subkeys, as you'll need your primary key to extend their
expiry dates anyway. I'm still deciding what my policy will be. Fortunately its fairly easy to chance expiry
dates after the fact. It's also a good idea to create a calendar entry to remind yourself when to extend them.

    Please specify how long the key should be valid.
             0 = key does not expire
          <n>  = key expires in n days
          <n>w = key expires in n weeks
          <n>m = key expires in n months
          <n>y = key expires in n years
    Key is valid for? (0) 1y

Enter your [name and e-mail<sub>7</sub>][7]. You'll get the option to add more addresses later if you wish to. Leave the 
[comment<sub>6</sub>][6] field empty. In fact, [that last link is important<sub>6</sub>][6]. It has a lot to
say about how you identify yourself to others. It's worth reading.

    GnuPG needs to construct a user ID to identify your key.
    
    Real name: Rick Roller
    Email address: rick@roll.com
    Comment:
    You selected this USER-ID:
        "Rick Roller <rick@roll.com>"
    
    Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit?

Choose a suitably secure [password<sub>8</sub>][8]. I've used a randomly-generated 24 character password consisting of
a mix of letters (upper and lower case), numbers and special characters. No, I'm not going to remember it. I'll have it 
written down and securly stored offline, along with my primary key once I'm done. It's seldomly used, so this is OK. 

    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    gpg: key 3714877A marked as ultimately trusted
    public and secret key created and signed.

Now you'll need to generate some entropy for the key generation. This take a second or two, or very much longer, depending
on algorithm selected, key length, and the OS and hardware that you're running on.

If everything went OK, you should get something similar to this

    gpg: checking the trustdb
    gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
    gpg: depth: 0  valid:   3  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 3u
    gpg: next trustdb check due at 2017-04-13
    pub   4096R/3714877A 2016-04-13 [expires: 2017-04-13]
          Key fingerprint = D067 6D8E 5AB5 B780 E748  E7D8 C9FA FEAA 3714 877A
    uid       [ultimate] Rick Roller <rick@roll.com>

Create one subkey each for sign, encrypt and authenticate

## Set algorithm preferences

https://debian-administration.org/users/dkg/weblog/48
personal-digest-preferences SHA256
cert-digest-algo SHA256
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

https://userbase.kde.org/Concepts/OpenPGP_Getting_Started#Algorithm_preferences
personal-cipher-preferences AES256,AES192,AES,CAST5,3DES
personal-digest-preferences SHA512,SHA384,SHA256,SHA224,RIPEMD160,SHA1
cert-digest-algo SHA512
default-preference-list AES256,AES192,AES,CAST5,3DES,SHA512,SHA384,SHA256,SHA224,RIPEMD160,SHA1,ZLIB,BZIP2,ZIP

https://help.riseup.net/en/security/message-security/openpgp/best-practices#stated-digest-algorithm-preferences-must-include-at-least-one-member-of-the-sha-2-family-at-a-higher-priority-than-both-md5-and-sha1
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed


http://security.stackexchange.com/questions/82216/how-to-change-default-cipher-in-gnupg-on-both-linux-and-windows#82219


https://github.com/ioerror/duraconf/blob/master/configs/gnupg/gpg.conf


## Creating the subkeys

From here onwards, you'll be editing the primary key you just created. You'll get into *edit mode*
by entering ```gpg --expert --edit-key rick@roll.com```, obviously substituting in the email address
that you selected. I'll use this fake address consistently from here on.

    gpg (GnuPG) 2.0.30; Copyright (C) 2015 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    
    Secret key is available.
    
    pub  4096R/3714877A  created: 2016-04-13  expires: 2017-04-13  usage: C
                         trust: ultimate      validity: ultimate
    [ultimate] (1). Rick Roller <rick@roll.com>
    


### Add a photo

There is some disagreement about whether this is a good idea or not. Personally, I like it,
especially if the photo matches up with one used on a social media account. Don't depend on
the photo when certifying other though.

    Pick an image to use for your photo ID.  The image must be a JPEG file.
    Remember that the image is stored within your public key.  If you use a
    very large picture, your key will become very large as well!
    Keeping the image close to 240x288 is a good size to use.
    
    Enter JPEG filename for photo ID: photo.jpg
    Is this photo correct (y/N/q)? y
    
    You need a passphrase to unlock the secret key for
    user: "Rick Roller <rick@roll.com>"
    4096-bit RSA key, ID 3714877A, created 2016-04-13
    
    pub  4096R/3714877A  created: 2016-04-13  expires: 2017-04-13  usage: C
                         trust: ultimate      validity: ultimate
    [ultimate] (1). Rick Roller <rick@roll.com>
    [ unknown] (2)  [jpeg image of size 5986]

setpref SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

# Links

None of this work is my own. I've merely collated resources from others who hopefully know better
and compiled it in such a way that is useful for me, and made a few tweaks here and there to suit my 
use cases. Most of my information has been extracted from these articles.

 * [OpenPGP Best Practices](https://help.riseup.net/en/security/message-security/openpgp/best-practices)
 * [Generating More Secure GPG Keys: A Step-by-Step Guide](https://spin.atomicobject.com/2013/11/24/secure-gpg-keys-guide/)
 * [Creating the perfect GPG keypair](https://alexcabal.com/creating-the-perfect-gpg-keypair/)

## References

This is a summary of the specific resources that I've referenced in my post to justify some of the decisions I've made. 

[1]:https://userbase.kde.org/Concepts/OpenPGP_Getting_Started#Key_type_and_length
[2]:https://help.riseup.net/en/security/message-security/openpgp/best-practices#only-use-your-primary-key-for-certification-and-possibly-signing-have-a-separate-subkey-for-encryption
[3]:https://help.riseup.net/en/security/message-security/openpgp/best-practices#use-a-strong-primary-key
[4]:https://userbase.kde.org/Concepts/OpenPGP_Getting_Started#Key_expiration
[5]:https://help.riseup.net/en/security/message-security/openpgp/best-practices#use-an-expiration-date-less-than-two-years
[6]:https://www.debian-administration.org/users/dkg/weblog/97
[7]:https://userbase.kde.org/Concepts/OpenPGP_Getting_Started#User_IDs
[8]:https://userbase.kde.org/Concepts/OpenPGP_Getting_Started#Passphrase.2C_safe_storage.2C_and_backup

[10]:https://userbase.kde.org/Concepts/OpenPGP_For_Beginners
[11]:https://userbase.kde.org/Concepts/OpenPGP_Getting_Started
[12]:https://www.gnupg.org/documentation/manuals/gnupg/


 
 1. [https://userbase.kde.org/Concepts/OpenPGP_Getting_Started#Key_type_and_length][1]   
 2. [https://help.riseup.net/en/security/message-security/openpgp/best-practices#use-a-strong-primary-key][2]
 3. [https://spin.atomicobject.com/2013/11/24/secure-gpg-keys-guide/][3]
 4. [https://www.debian-administration.org/users/dkg/weblog/97][4] 
 
 {{ page.output }}