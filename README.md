```
███╗   ███╗███████╗      ██████╗ ██╗███████╗
████╗ ████║██╔════╝      ██╔══██╗██║██╔════╝
██╔████╔██║███████╗█████╗██║  ██║██║███████╗
██║╚██╔╝██║╚════██║╚════╝██║  ██║██║╚════██║
██║ ╚═╝ ██║███████║      ██████╔╝██║███████║
╚═╝     ╚═╝╚══════╝      ╚═════╝ ╚═╝╚══════╝
                                            
```

## Installation
```
git clone https://github.com/gorczyca/MS-DIS
cd MS-DIS
pip install .
```


### Verify installation
#### ABA: 
```
msdis -p test-instances/aba-test-instance.lp -g q4 -f aba 
```
should return `False`, whereas:
```
msdis -p test-instances/aba-test-instance.lp -g a4 -f aba 
```
should return `True`

#### AF:
```
msdis -p test-instances/af-test-instance.lp -g 36 -f af 

```
returns `True` and:
```
msdis -p test-instances/af-test-instance.lp -g 2 -f af 

```
returns `False`