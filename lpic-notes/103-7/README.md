# Search text files using regular expressions

We will deep dive into regex.

## atoms (metacharacters)

Single characters with special meaning:
* .(dot): any single char
* ^(caret): beginning of a line
* $(dollar sign): end of a line


## bracket expressions []

Any one character from a defined set:
* [aeiou]: list of chars
* [a-z]: range of chars
* [^0-9]: negation
Special classes:
* [[:digit:]]: same as [0-9]
* [[:alpha:]]: any letter
* [[:space:]]: whitespace characters (space, tab, etc.)

## quantifiers

How many times the preceding atom must appear:
* *: zero or more times (a\* matches "", "a", "aa"...)
* +: one or more times (a+ matches "a", "aa", "aaa"...)
* ?: zero or one time (colou?r matches "color" and "colour")
* {}(bounds): precise counts ([0-9]{3} for exactly three digits and [0-9]{2,4} for between two and four digits)

## grouping and branching

Multiple patterns combined:
* | (branc/OR): match either (cat|dog matches "cat" or "dog")
* () (grouping): groups a sub-pattern, useful for later reference (([a-z])\1 would match any two identical lowercase letters in a row)

## basic and extended regex

The extended is modern and has intuitive style like +,?,|,() and {} are automatically recognized. However, the basic is older and must use **escape them** with a backslash (\+, \?, \|...). For compatibility, always suggest that the host system is limited on basic regex.