```
███╗   ███╗███████╗      ██████╗ ██╗███████╗
████╗ ████║██╔════╝      ██╔══██╗██║██╔════╝
██╔████╔██║███████╗█████╗██║  ██║██║███████╗
██║╚██╔╝██║╚════██║╚════╝██║  ██║██║╚════██║
██║ ╚═╝ ██║███████║      ██████╔╝██║███████║
╚═╝     ╚═╝╚══════╝      ╚═════╝ ╚═╝╚══════╝
                                            
```

## Installation
Run the following in the project directory:
```
pip install .
```


## Running:
Running works as required by the ICCMA'25 specification. E.g.
```
user$ msdis
```
Returns:
```
MS-DIS v1.0
Piotr Gorczyca, piotr.gorczyca@tu-dresden.de
Martin Diller, martin.diller@tu-dresden.de
```

and:
```
user$ msdis --problems
```
prints:
```
[DC-CO,DC-ST]
```

Finally:
```
user$ msdis -p DC-ST -f test-instances/example-aba.iccma -a 7
```
returns `YES`, while:
```
user$ msdis -p DC-ST -f test-instances/example-aba.iccma -a 5
```
returns `NO`.