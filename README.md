## Build Settings ##
**POS**

If you want to build a POS project, you must open in `Build Settings`, open `Build Steps` and choose `Additional arguments:`

```
DEFINES+=POS_BUILD
```

**WALLET**

If you want to build a WALLET project, you must open in `Build Settings`, open `Build Steps` and choose `Additional arguments:`

```
DEFINES+=WALLET_BUILD
```

## Cloning ##

Clone from upstream while borrowing from an existing local directory:

```
$ git clone --recursive https://git.vakoms.com/qt-team/graft-mobile-client.git
```

Also, if you run `git clone` **non-recursively**, you need to run:

```
$ git clone https://git.vakoms.com/qt-team/graft-mobile-client.git
$ git submodule init
$ git submodule update
```
