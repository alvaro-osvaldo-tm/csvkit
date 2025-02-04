# Implementation

Implemented the feature to optionality add Byte Order Mark (BOM) into output CSV content.

# Solution

- The BOM only will be added if the parameter '--add-bom' is specified, otherwise is ignored.
- The parameter configuration and execution was implemented in the file `csvkit/features/AddBOM.py` , I used a 'feature' pattern to avoid 'spaghetti code', no problem is the code need to be put into `CSVKitUtility` class. 
  - The advantage of this approach is the code is more clear.
  - The disadvantage of this approach is it require a few more CPU cycles. That can be a problem if the user have a HUGE amount of batch processing files.  
 - The implementation uses `locale.getencoding()` to define the correct BOM 

# Tests

- There is end-to-end testing attached to this message.

# Checklist

# Considerations


# References

- _A BOM Discovery Algorithm_.DetectType(): https://invent.kde.org/utilities/kate/-/blob/master/3rdparty/rapidjson/encodedstream.h

- _A Specification for BOM usage_.RFC 2781. 3.2 Byte order mark (BOM): https://www.ietf.org/rfc/rfc2781.txt

  - _Feature Pattern_.https://martinfowler.com/articles/feature-toggles.html


