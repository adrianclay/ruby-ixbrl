# Ixbrl

[![Build Status](https://travis-ci.org/adrianclay/ruby-ixbrl.svg?branch=master)](https://travis-ci.org/adrianclay/ruby-ixbrl)

Limited library of ixbrl related functions.

* ```Ixbrl::DocumentParser.get_items_under_instants``` pulls out xbrl elements from a document keyed by context instant.
```ruby
{
  '2012-01-01' => {
    'http://www.xbrl.org/uk/gaap/core/2009-09-01:CurrentAssets' => 180.0,
    ...
  }
}
```

* ```Ixbrl::ImportAccountsToElasticSearch.import_companies_house_archive``` pulls out xbrl elements from a
  [Companies House archive](http://download.companieshouse.gov.uk/en_accountsdata.html) and pushes them to an
  [ElasticSearch](https://github.com/elastic/elasticsearch) server.


```shell
# Bring up Elasticsearch server
docker-compose up -d
# Start interactive ruby shell
./bin/console
```

```ruby
# See http://www.rubydoc.info/gems/elasticsearch-transport/5.0.1/Elasticsearch/Transport/Client#initialize-instance_method
import = Ixbrl::ImportAccountsToElasticSearch.new(Elasticsearch::Client.new)
# Download zips from http://download.companieshouse.gov.uk/en_accountsdata.html
import.import_companies_house_archive("spec/ch_09175128.zip")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adrianclay/ixbrl.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

