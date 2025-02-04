# Implementation

Implemented the feature to optionality add Byte Order Mark (BOM) into output CSV content in all utilities except `csvpy` and `sql2csv`

# Solution

- The BOM only will be added if the parameter '--add-bom' is specified, otherwise is ignored.
- The parameter configuration and execution was implemented in the file `csvkit/features/AddBOM.py` , I used a 'feature' pattern to avoid 'spaghetti code', no problem is the code need to be put into `CSVKitUtility` class. 
  - The advantage of this approach is the code is more clear.
  - The disadvantage of this approach is it require a few more CPU cycles. That can be a problem if the user have a HUGE amount of batch processing files.  
 - The implementation uses `locale.getencoding()` to define the correct BOM 

# Tests

- There is end-to-end testing attached to this message, only the 'dummy.xls' example was used for testing.
- The same script was tested with the following Pythons implementations: 
  - Python 3.8
- No other tests was made.

# Checklist



# Considerations

**Python Deprecation**

```
DEPRECATION: Legacy editable install of csvkit[test]==2.0.1 from file:///home/alvaro/Desktop/Alvaro%20Osvaldo%20Dev/Externals/Customers/CSVKit/Programs/CSVKit%20Implementation/development (setup.py develop) is deprecated. pip 25.1 will enforce this behaviour change. A possible replacement is to add a pyproject.toml or enable --use-pep517, and use setuptools >= 64. If the resulting installation is not behaving as expected, try using --config-settings editable_mode=compat. Please consult the setuptools documentation for more information. Discussion can be found at https://github.com/pypa/pip/issues/11457
```


**Edge Cases**


For some utilities there is some bugs for edge cases when not coding with UTF-8. 

All is show in the test script, and i don't have tracked the problem to know if happens
due the CSVToolkit or due 'agate' library.

For the specific case for CSVStat , for UTF-32LE ( Little Endian ), there is a warning message from 'agate' 
and 'Contains null values' show as 'True' and 'Most common values' show the 'None', both results should not exist. 

The failure can be tested with the code below:

```bash
$ PYTHONIOENCODING=UTF-32LE in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING=UTF-32LE csvstat -d , --add-bom -
# .../site-packages/agate/table/from_csv.py:83: RuntimeWarning: Error sniffing CSV dialect: Could not determine delimiter
#  kwargs['dialect'] = csv.Sniffer().sniff(sample)
# ...
# Contains null values:  True (excluded from calculations)
# ...
#        Most common values:    3.0 (1x)
#                               None (1x)


```
However, all works fine with the same command when is coded with UTF-32BE ( Big Endian ) as shows below: 

```bash
$ PYTHONIOENCODING=UTF-32BE in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING=UTF-32BE csvstat -d , --add-bom -
# All works fine
```

# References

- _A BOM Discovery Algorithm_.DetectType(): https://invent.kde.org/utilities/kate/-/blob/master/3rdparty/rapidjson/encodedstream.h

- _A Specification for BOM usage_.RFC 2781. 3.2 Byte order mark (BOM): https://www.ietf.org/rfc/rfc2781.txt

  - _Feature Pattern_.https://martinfowler.com/articles/feature-toggles.html


