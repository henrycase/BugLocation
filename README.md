# BugLocation

Attempt to use the services interfaces on the Bug YT from Clojure.

## Usage

### Quick Start
```
lein deps
lein run <bug ip>
```

### Explained
If you are running on a desktop machine, pass the IP address of the
Bug as argument to `lein run`. If you want to deploy the jarfile to
the Bug, run the included `deploy.sh` script with the username and IP
address of the Bug; e.g.

```
./deploy.sh root@192.168.2.5
```

This will build a jarfile, copying the jarfile, the file `environ.sh`
(which should contain any configuration environment variables), and
a generated `run.sh`. The `run.sh` is a wrapper around the jarfile,
and will also source `environ.sh`. Any arguments passed to the script
will be passed to the jarfile.

## License

Copyright (C) 2012 Henry Case <henry@metacircular.net>.

Released under an ISC license.
