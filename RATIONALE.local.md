# Implementation

Implemented the feature to optionality add UTF-8 Byte Order Mark (BOM) into output content in all utilities,
except `csvpy` and `sql2csv`

## Solution

- The UTF-8 BOM only will be added if the parameter '--add-bom' is specified, otherwise is ignored.
- The parameter configuration and execution was implemented in the file `csvkit/features/AddBOM.py` , 
I used a 'feature' pattern to avoid 'spaghetti code', no problem is the code need to be put into `CSVKitUtility` class. 
  - The advantage of this approach is the code is more clear.
  - But the CSVToolKit is not prepared for it as seen in '`argument`' method. Also, if the user process a HUGE amount 
  of file will perceive a few more CPU cycles per file.  

## Tests

- In this pull request is a end-to-end test script.
- No unit test was made because the test use 'StringIO' as 'input file', 
  but the BOM need to be added as bytes using 'TextIOWrapper'.
  - If you want, I can implement a conversion 'CSVToolkit' and 'LazyFile' classes to enable the tests.  
 
- All `PyTests` and `end-to-end` tests passed in the following versions:
  - Python 3.8.20
  - Python 3.9.21
  - Python 3.10.16
  - Python 3.11.11
  - Python 3.12.8
    - Except `csvgrep` and `csvcut` due `CSVToolkit`bug.

## Checklist

- [ ] Unit Testing
- [x] End-to-end Testing

## Considerations

### Bugs Found

I found some bugs, I will open an issue in github for each one and describe here for acknowledge.

**Failures in Python 3.12**

Some CSVToolkit is failing in Python 3.12 in the '`master`' branch.
The following command fails getting a weird output in console:

```bash
$ in2csv -e utf-16   ./examples/test_utf16_little.csv |  csvgrep   --column a -m 1.0 -
# ["['a'", " 'b'", " 'c']"]
# ColumnIdentifierError: Column 'a' is invalid. It is neither an integer nor a column name. Column names are: "['a'", " 'b'", " 'c']"
```

Perhaps is due Python 3.12, breaking changes as in argument processing the line below return `list` in Python 3.12 
and `Namespace` class in other versions. 

```python
self.args = self.argparser.parse_args(args)
```
 **Ignoring PythonIOEnconing**

I think the implementation for the `PYTHONIOENCONDING` environment variable is not complete.

Because, if these variable is set all Python input should expected with these enconding, but even is set the parameter
`--enconding` must be defined to work.

For example both commands belows are analogs and produce the same output.

```bash
$ PYTHONIOENCONDING=utf-16 csvstat  ./examples/test_utf16_little.csv
$ csvstat -e utf-16   ./examples/test_utf16_little.csv
```

But only the second works, the first responds with `Your file is not "utf-8-sig" encoded. Please specify the correct 
encoding with the -e flag or with the PYTHONIOENCODING environment variable. Use the -v flag to see the complete error.
` and in special this sentence `with the -e flag **or** with the PYTHONIOENCODING environment variable` I interpret 
has both cases should work.


**Setup.py**

The current installation uses 'setup.py' it is deprecated and due security concerns and will fail in the next 
pip 25.1 update , it should be migrated to `project.toml` file

### Opportunities

If a plugin-in architecture is implemented , it allow developter to extend `csvkit` with their own modules to get
the csv file from cloud or others source.

Somenting like:

```bash
$ pip3 install csvkit-source-s2
$ pip3 install csvkit-format-parquet
$ in2cv s2://file.parquet > file.csv
$ in2cv ./my-file.parquet > ./my-file.csv 
```
The same should happen if an `output` parameter is added:

```bash
$ in2cv file.csv --output s2://file.parquet 
```

### Other considerations

- The CSVToolkit architecture **always** output in UTF-8, even if `PYTHONIOENCONDING` environment variable is set, 
therefore, only UTF-8 BOM is supported.


## References

- _Feature Pattern_.https://martinfowler.com/articles/feature-toggles.html


