# Message Sequence Charts (MSC)

## Table of contents

* [What's included](#whats-included)
* [People Power MSC](#peoplepower-msc)
* [Usage](#usage)

## Classes

* [Apps](apps/README.md)

## What's included

Within the download you'll find the following directories and files. You'll see something like this:

```
diagrams/
│
├── class/
│	│
│	└── component/
│       │
│	    ├── sequence.eps
│	    └── sequence.msc
│	
├── generateDiagrams.sh
│
└── README.md
```

## People Power MSC

The People Power Message Sequence Charts (MSC) contains diagrams on integral logical flows for our clients, including user registration and sign on and device on-boarding.

Use it to:

* Understand communication sequences and processes
* Explore examples of client scenarios

For a complete definition of People Power's models and APIs, please refer to [IOT Apps](https://iotapps.docs.apiary.io/) on Apiary.

### Installation

This project uses the program [mscgen](http://www.mcternan.me.uk/mscgen/).  Packages and installation instructions are provided by the program developers.

### Usage

This project is meant as a resource and diagrams are already rendered and included.

To make updates to existing charts, or add new charts, apply your changes and then run the bash script `./generateDiagrams.sh` to regenerate all eps diagrams.