```
███╗   ███╗███████╗      ██████╗ ██╗███████╗
████╗ ████║██╔════╝      ██╔══██╗██║██╔════╝
██╔████╔██║███████╗█████╗██║  ██║██║███████╗
██║╚██╔╝██║╚════██║╚════╝██║  ██║██║╚════██║
██║ ╚═╝ ██║███████║      ██████╔╝██║███████║
╚═╝     ╚═╝╚══════╝      ╚═════╝ ╚═╝╚══════╝
                                            
```


### Verify installation
#### ABA: 
```
python msdis.py -p test-instances/aba-test-instance.lp -g q4 -f aba 
```
should return `False`, whereas:
```
python msdis.py -p test-instances/aba-test-instance.lp -g a4 -f aba 
```
should return `True`

#### AF:
```
python msdis.py -p test-instances/af-test-instance.lp -g 36 -f af 

```
returns `True` and:
```
python msdis.py -p test-instances/af-test-instance.lp -g 2 -f af 

```
returns `False`