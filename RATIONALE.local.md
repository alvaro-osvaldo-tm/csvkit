Implementation

Implemented the capability to optionality save Byte Order Mark (BOM) into CSV Files.

Solution

- The BOM only will be added when the parameter '--add-bom' is specified, otherwise the capability is ignored. 
- As there is no parameter in 'in2csv' to convert the  file *coding output* to any format than defined by Python, it uses _locale.getencoding()_ to define the correct BOM 

Tests

Checklist

Considerations

References

- _A BOM Discovery Algorithm_.DetectType(): https://invent.kde.org/utilities/kate/-/blob/master/3rdparty/rapidjson/encodedstream.h


- _A Specification for BOM usage_.RFC 2781. 3.2 Byte order mark (BOM): https://www.ietf.org/rfc/rfc2781.txt
    

