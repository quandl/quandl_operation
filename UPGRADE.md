## 0.4.1 





## 0.4.0 

* QUGC-189 dont require active_support/object



## 0.3.1

* value precision should ignore nils
* add Operation::Value with Value.precision for setting data value precision
* refactor collapse operation to expect Date


## 0.3.0

* extract Parse to Quandl::Data. Add Sort


## 0.2.1

* assert valid arguments for collapse and transform
* fix parse_date_string jd


## 0.2.0

* rename Parse methods to be more informative
* add qdate
* reject dates that preceed time
* add Quandl::Operation::Errors
* add Quandl::Operation::Errors::UnknownDateFormat
* Quandl::Operation::Parse.perform(data)
* outputs dates as Date instead of Integer
* invalid dates raise date_format_error with informative message


## 0.1.22

* refactor QDFormat to support full yaml. metadata and data are seperated by a


## 0.1.21

* QDFormat should handle new lines in attributes


## 0.1.20

* qdformat#to_qdf
* QDFormat::Node#attributes should include data


## 0.1.18

* Add QDFormat


## 0.1.17

* bump quandl_logger to 0.2.0


## 0.1.15

* Collapse.collapses_greater_than should return [] given nil


## 0.1.13

* add utilities to core_ext


## 0.1.12

* Quandl::Operation::Collapse.perform will merge rows with nils


## 0.1.11

* it should parse escaped csv data

## 0.1.10

* Parse can handle incoming data formatted as a hash of time => [value,value,value]

## 0.1.9

* write failing spec for cumul. make spec pass

## 0.1.8

* add Collapse.collapses_greater_than_or_equal_to(freq) add Collapse.collapses_greater_than(freq)

## 0.1.7

* date start_of_frequency given invalid input should return the date

## 0.1.0

Initial