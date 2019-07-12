dadapush-bash
===========

Shell script wrapper around curl for sending messages through DaDaPush.

[DaDaPush: Real-time Notifications App][1]
===========

Send real-time notifications through our API without coding and maintaining your own app for iOS or Android devices.


Installation
============

To install `dadapush-bash`, run

```
git clone https://github.com/dadapush/dadapush-bash.git;
cd dadapush-bash;
chmod +x dadapush.sh;
```

Usage
=====
```
    dadapush.sh <options> <message>
     -T <TOKEN>
     -m <msg_file>
```
Example
=====
```
    dadapush.sh -T YOUR_TOKEN -m message-example.json
```

[1]: https://www.dadapush.com
[2]: https://github.com/dadapush/dadapush-bash/issues
