# Quandl::Operation

## Purpose

The purpose of this gem is to modify time-series array data by:

- collapse
- transform
- sort


## Installation

```ruby
gem 'quandl_operation'
```


## Usage

```ruby

data = [[2456461, 1, 2, 3],[2456460, 2, 3, 4]]

Quandl::Operation::Collapse.perform(data, :weekly)
Quandl::Operation::Transform.perform(data, :rdiff)


```