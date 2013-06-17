# Quandl::Operation

```ruby

data = [[2456461, 1, 2, 3],[2456460, 2, 3, 4]]

Quandl::Operation::Collapse.perform(data, :weekly)
Quandl::Operation::Transform.perform(data, :rdiff)


csv = "2456461,9.992941176470588,10.974117647058824\n2456459,9.960611072664358,10.92053813148789\n"

Quandl::Operation::Parse.perform(csv)

```